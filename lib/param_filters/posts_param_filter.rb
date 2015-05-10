class PostsParamFilter < ParamFilter

  LEAGUE_JOIN_KEY = :leaguejoin

  class << self
    def custom_params
      super + %w(q league_type)
    end

    def exclusions
      %w(id league_id post_id league_type user_id deleted_at)
    end

    def possible_hockey_league_params
      possible_params_for_class HockeyLeague, %w(id), joinable_keys: LEAGUE_JOIN_KEY
    end

    def possible_football_league_params
      possible_params_for_class FootballLeague, %w(id), joinable_keys: LEAGUE_JOIN_KEY
    end

    def possible_baseball_league_params
      possible_params_for_class BaseballLeague, %w(id), joinable_keys: LEAGUE_JOIN_KEY
    end
  end

  def joinables
    !!filtered_league_type ? {LEAGUE_JOIN_KEY => filtered_league_type} : {}
  end

  def filter_league_type(value)
    return value if LeagueLike::ALL_LEAGUE_CLASSES.map(&:to_s).include?(value)
  end

  def filter_q(value)
    return value.to_s.split /\W+/
  end

  def filter_sort_order(value)
    table, column = value.split '.'
    super_value   = super(value)
    return super_value if !!super_value || !column

    # Handle any sorting of joined tables
    filtered_class = self.class.filtered_class
    filtered_table = filtered_class.table_name

    if !!filtered_league_type
      # Already joining a certain league type, so we must limit the ordering to
      # that league's attributes.
      if can_order_by_table_column?(filtered_league_type.constantize, table, column)
        [table, column].join '.'
      end
    elsif filtered_league_type = filter_league_type(table.classify)
      if can_order_by_table_column?(table.classify.constantize, table, column)
        [table, column].join '.'
      end
    end
  end


  private

  def filtered_league_type
    @filtered_league_type ||= filter_league_type(initial_params[:league_type])
  end

  # Only `Post` params if `league_type` is nil.
  # Otherwise, include params based on `league_type`.\
  def possible_params
    super + possible_league_params
  end

  def possible_league_params
    if !!filtered_league_type
      league_param_ivar_name = "#{filtered_league_type.underscore}_params"
      memoized_league_params = instance_variable_get "@#{league_param_ivar_name}"
      memoized_league_params ||= instance_variable_set "@#{league_param_ivar_name}", self.class.public_send("possible_#{league_param_ivar_name}")
    else
      []
    end
  end
end