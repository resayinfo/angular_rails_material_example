class QueryFilter

  def self.default_sort_order
    "#{arel_table.name}.created_at"
  end

  def self.default_sort_direction
    :DESC
  end

  def self.default_query_limit
    25
  end

  def initialize(params, ability)
    p = params.with_indifferent_access

    @filtered_params = self.class.param_filter.new(p).filtered_params
    @ability         = ability
  end

  def run_query
    records = self.class.query_class.accessible_by ability
    records = apply_joins records
    records = apply_params records
    records = apply_preloads records
    records = apply_order records
    records = apply_limit records
    records
  end


  private
  attr_reader :filtered_params, :ability, :join_sources, :preload_sources

  def self.query_class_name
    @query_class_name ||= name.gsub('QueryFilter','')
  end

  def self.query_class
    @query_class ||= query_class_name.singularize.constantize
  end

  def self.param_filter
    @param_filter ||= "#{query_class_name}ParamFilter".constantize
  end

  def self.arel_table
    query_class.arel_table
  end

  def self.arel_comparison(f_param)
    node  = f_param.arel_table[f_param.name]
    value = f_param.value

    case f_param.comparator
      when ParamFilter::COMPARATORS[:greater_than]; node.gt(value)
      when ParamFilter::COMPARATORS[:less_than]; node.lt(value)
      when ParamFilter::COMPARATORS[:like]; node.matches("%#{value}%")
      when ParamFilter::COMPARATORS[:equals]; node.eq(value)
      when ParamFilter::COMPARATORS[:none]; node.eq(value)
    end
  end

  def apply_preloads(records)
    if ps = preload_sources
      records.preload *ps
    else
      records
    end
  end

  def apply_joins(records)
    if js = join_sources
      records.joins js
    else
      records
    end
  end

  def apply_params(records)
    filtered_params.each do |name, fp|
      if !fp.value.nil? && !fp.custom?
        # Custom `filtered_params` must be utilized explicitly.. usually by overriding this method.
        records = records.where self.class.arel_comparison(fp)
      end
    end

    records
  end

  def apply_order(records)
    order = filtered_params[ParamFilter::SORT_ORDER_KEY]

    order_string = if order && order.value
      "#{order.value} #{filtered_params[ParamFilter::SORT_DIRECTION_KEY].value}"
    else
      "#{self.class.default_sort_order} #{filtered_params[ParamFilter::SORT_DIRECTION_KEY].value}"
    end

    records.order order_string
  end

  def apply_limit(records)
    limit         = filtered_params[ParamFilter::QUERY_LIMIT_KEY]
    limit_value   = limit && limit.value
    limit_value ||= self.class.default_query_limit

    records.page(1).per limit_value
  end
end