module ApplicationHelper

  # These are passed as data attributes on the body. So, they must be
  # hyphenated.
  def app_data_for_angular
    {
      'current-user'   => current_user.to_json(ability: current_ability),
      'league-types'   => league_type_objects_array.to_json,
      'flash-messages' => serialized_flash_messages.to_json,
      'default-sort-order' => PostsQueryFilter.default_sort_order,
      'sort-order-param' => ParamFilter::SORT_ORDER_KEY,
      'default-query-limit' => QueryFilter.default_query_limit,
      'query-limit-param' => ParamFilter::QUERY_LIMIT_KEY,
      'sort-direction-param' => ParamFilter::SORT_DIRECTION_KEY
    }
  end

  # render all views in script tags which angular can recognize
  def preload_all_views_for_angular(opts={})
    directories  = Dir.glob("#{base_views_directory}/**/*.html*")
    directories  = strip_excluded_directories(directories, opts[:exclude])
    views_string = ''

    directories.each do |d|
      id   = relative_view_filename d
      view = render file: Rails.root.join(d).to_s
      views_string += content_tag(:script, view, type: 'text/ng-template', id: id)
    end

    views_string.html_safe
  end

  def grouped_filter_options
    post_options   = filter_options_for_param_group Post, ParamFilter.possible_params_for_class(Post, PostsParamFilter.exclusions)
    league_options = LeagueLike::ALL_LEAGUE_CLASSES.inject({}) do |hsh, klass|
      klass_str = klass.to_s
      hsh[klass_str.titleize] = filter_options_for_param_group(klass, PostsParamFilter.public_send("possible_#{klass_str.underscore}_params"), PostsParamFilter::LEAGUE_JOIN_KEY)
      hsh
    end

    {Post: post_options}.merge league_options
  end

  def grouped_order_options
    post_options   = order_options_for_model Post, %w(id body user_id post_id league_id league_type deleted_at)
    league_options = LeagueLike::ALL_LEAGUE_CLASSES.inject({}) do |hsh, klass|
      hsh[klass.to_s.titleize] = order_options_for_model(klass)
      hsh
    end

    {Post: post_options}.merge league_options
  end

  def input_for_type(type)
    input_class = 'form-control floating-label search-value-input'
    case type
      when :string
        content_tag(:input, nil, type: :text, placeholder: 'text', class: input_class, "ng-model"=>"#{type}Value")
      when :integer
        number_field_tag nil, 0, class: input_class, "ng-model"=>"#{type}Value", placeholder: 'text'
      when :boolean
        select_tag nil, options_for_select([ true, false ], true), class: input_class, "ng-model"=>"#{type}Value", placeholder: 'text'
      when :decimal
        number_field_tag nil, 0, step: 0.1, class: input_class, "ng-model"=>"#{type}Value", placeholder: 'text'
      when :datetime
        content_tag(
          :input,
          nil,
          placeholder: 'text',
          class: [input_class, :datepicker],
          "ng-model"=>"#{type}Value",
          'data-provide'=> 'datepicker',
          'data-date-format'=> 'mm/dd/yyyy',
          'data-date-autoclose'=> true,
          'data-date-today-highlight' => true
        )
    end
  end


  private

  def order_options_for_model(klass, exclusions=nil)
    klass.columns_hash.inject([]) do |arr, column|
      param_name, attrs = column
      unless Array(exclusions).include?(param_name)
        table_name = klass.table_name
        arr << { text: param_name.titleize, id: "#{table_name}.#{param_name}", input_type: attrs.type, klass: klass.to_s }
      end
      arr
    end
  end

  def filter_options_for_param_group(klass, all_params, joinable_key=nil)
    all_columns = klass.columns_hash
    all_params.inject({}) do |hsh, param|
      prefix, name, comparator = PostsParamFilter.split_name(param, joinable_key)
      if comparator != ParamFilter::COMPARATORS[:none] # skip duplicate params for `equals` Comparator
        readable_comparator = ParamFilter::COMPARATORS.inject(nil) do |last, current|
          if last.present?
            last
          elsif comparator == current[1]
            current[0].to_s
          end
        end

        readable_name = "'#{name.titleize}' #{readable_comparator.titleize}"
        hsh[param] = { text: readable_name, id: param, input_type: all_columns[name].type, klass: klass.to_s }
      end
      hsh
    end
  end

  def league_type_objects_array
    LeagueLike::ALL_LEAGUE_CLASSES.map do |c|
      league_class_name = c.to_s
      short_name        = league_class_name.gsub('League','')

      {
        name: league_class_name,
        shortName: short_name
      }
    end
  end

  def base_views_directory
    'app/views'
  end

  def relative_view_filename(filepath)
    # trim base path
    relative_path = filepath.split(base_views_directory)[1] || ''

    if relative_path.present?
      # trim file extensions
      relative_path = relative_path.split('.')[0] || ''

      if relative_path.present?
        # trim underscore from partial names
        relative_path = relative_path.gsub('/_', '/')
      end
    end

    relative_path + '.html'
  end

  def strip_excluded_directories(directories, exceptions=[])
    directories.reject{|d| filename_excluded?(d, exceptions) }
  end

  def filename_excluded?(filename, exceptions)
    Array(exceptions).map(&:to_s).each do |exc|
      return true if filename.include?(exc)
    end
    return false
  end

  def serialized_flash_messages
    flash.map do |type, message|
      {
        type: type,
        message: message
      }
    end
  end
end
