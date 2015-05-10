class ParamFilter

  SORT_DIRECTION_KEY = 'sort_direction'
  SORT_ORDER_KEY     = 'sort_order'
  QUERY_LIMIT_KEY    = 'query_limit'
  COMPARATORS        = {
    greater_than: 'gt',
    less_than: 'lt',
    like: 'like',
    equals: 'eq',
    none: nil # a param without a suffix implies 'equals'
  }

  class << self
    attr_reader :exclusions

    def filtered_class
      @filtered_class ||= name.gsub('ParamFilter','').singularize.constantize
    end

    def custom_params
      [ SORT_ORDER_KEY, SORT_DIRECTION_KEY, QUERY_LIMIT_KEY ]
    end

    def possible_params_for_class(klass, exclusions, **options)
      joinable_keys = Array options[:joinable_keys]
      custom_keys   = Array options[:custom_keys]
      exclusions    = Array exclusions

      klass.columns_hash.inject(custom_keys) do |arr, column|
        param_name, param_attrs = column
        if exclusions.include?(param_name)
          arr
        else
          arr += possible_params_for_type( param_name, param_attrs.type, joinable_keys)
        end
      end
    end

    def possible_params_for_type(name, type, prefixes=nil)
      prefixes = [nil] if prefixes.blank?

      suffixes = case type
        when :integer
          COMPARATORS.slice(:greater_than, :less_than, :equals, :none).values
        when :decimal
          COMPARATORS.slice(:greater_than, :less_than, :equals, :none).values
        when :string
          COMPARATORS.slice(:like).values
        when :datetime
          COMPARATORS.slice(:greater_than, :less_than).values
        when :boolean
          COMPARATORS.slice(:equals, :none).values
        else
          [] # no querying `text` or other fields
      end

      suffixes.inject([]) do |arr, suffix|
        # For each suffix, add a param name with each of the prefixes.
        arr + prefixes.map{ |p| [p, name, suffix].compact.join('_') }
      end
    end

    def split_name(param_name, joinable_keys)
      all_suffixes = COMPARATORS.values
      s_name       = param_name.split '_'
      test_prefix  = s_name[0]
      test_suffix  = s_name[-1]
      comparator   = nil
      prefix       = nil

      all_suffixes.each do |s|
        if test_suffix == s.to_s
          comparator = s
          param_name = param_name.gsub("_#{comparator}", '')
          break
        end
      end

      Array(joinable_keys).each do |k|
        if test_prefix == k.to_s
          prefix = k
          param_name = param_name.gsub("#{prefix}_", '')
          break
        end
      end

      [prefix, param_name, comparator]
    end
  end

  ############################ end class methods ###############################

  def initialize(init_params)
    @initial_params = init_params.reverse_merge(sort_direction: :DESC)
  end

  # Returns a hash of `FilteredParam` objects.
  # The keys are the original param names.
  def filtered_params
    params.inject({}) do |hsh, p|
      p_name, p_value = p
      fp = FilteredParam.new(p_name, p_value, self)
      hsh[p_name.to_sym] = fp
      hsh
    end.with_indifferent_access
  end

  def filter_sort_order(value)
    table, column  = value.split '.'
    filtered_class = self.class.filtered_class
    filtered_table = filtered_class.table_name

    if !column
      # assume only a column name was given
      column = table
      table  = filtered_table
    end

    if can_order_by_table_column? filtered_class, table, column
      [table, column].join('.')
    end
  end

  def filter_query_limit(value)
    value.to_i unless value.nil?
  end

  def filter_sort_direction(value)
    value.upcase == :ASC.to_s ? :ASC : :DESC
  end

  def model_for_param_prefix(prefix=nil)
    if prefix
      if j = joinables[prefix.to_sym]
        return j.constantize
      end
    end

    return self.class.filtered_class # default to standard class
  end

  def method_missing(method_sym, *arguments, &block)
    if column_match = method_sym.to_s.match(/^filter_(.*)/)
      default_column_filter(column_match[1], arguments[0])
    else
      super
    end
  end

  def joinables
    {}
  end


  private
  attr_reader :initial_params

  def can_order_by_table_column?(filtered_class, table, column)
    filtered_class.table_name == table &&
    filtered_class.column_names.include?(column)
  end

  # All params are filtered with this unless there is a `filter_<param_name>` is defined.
  def default_column_filter(name, value)
    prefix       = name.split('_')[0]
    model_klass  = model_for_param_prefix prefix
    name = name.gsub("#{prefix}_", '') unless model_klass == self.class.filtered_class

    return nil unless attrs = model_klass.columns_hash[name]
    return nil if value.nil?

    case attrs.type
      when :integer
        value.to_i
      when :decimal
        value.to_f
      when :datetime
        Chronic.parse(value.to_s)
      when :string
        value.to_s
      when :boolean
        value.to_b
      else
        nil
    end
  end

  def params
    @params ||= utilized_params
  end

  def utilized_params
    initial_params.slice *possible_params
  end

  def possible_params
    self.class.possible_params_for_class(self.class.filtered_class, self.class.exclusions, custom_keys: self.class.custom_params)
  end

  class FilteredParam
    attr_reader :prefix, :name, :comparator, :initial_value, :parent_instance, :custom
    alias_method :custom?, :custom

    def initialize(param_name, param_value, parent_instance)
      @initial_value   = param_value
      @parent_instance = parent_instance
      @custom          = parent_instance.class.custom_params && parent_instance.class.custom_params.include?(param_name)
      @prefix, @name, @comparator = parent_instance.class.split_name(param_name, parent_instance.joinables.keys)
    end

    # Calls the filter function for each params name.
    # For a param like 'name', filter function must be defined as 'filter_name'.
    def value
      parent_instance.public_send [:filter, prefix, name].compact.join('_'), initial_value
    end

    def arel_table
      parent_instance.model_for_param_prefix(prefix).arel_table
    end
  end
end