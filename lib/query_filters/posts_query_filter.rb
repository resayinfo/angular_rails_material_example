class PostsQueryFilter < QueryFilter

  private


  def apply_params(records)
    records = super records
    records = records.where(league_type: league_type) if league_type
    q_node  = build_q_node

    q_node.nil? ? records : records.where(q_node)
  end

  # For each string `value` given to q, `(post.title ilike "%value%"" OR league.name ilike "%value%").
  # Each `value` subquery will be joined with an `AND` to ensure all of the conditions are met.
  def build_q_node
    return nil unless q = filtered_params[:q]

    q_node = nil

    q.value.each do |value|
      fuzzy_string = "%#{value}%"
      temp_node    = self.class.arel_table[:title].matches(fuzzy_string)

      if league_type
        temp_node = temp_node.or(
          league_type.constantize.arel_table[:name].eq(fuzzy_string)
        )
      end

      q_node = q_node.nil? ? temp_node : q_node.and(temp_node)
    end

    q_node
  end

  def league_type
    sort_order_key = ParamFilter::SORT_ORDER_KEY

    if !!filtered_params[:league_type] && filtered_params[:league_type].value
      return filtered_params[:league_type].value
    elsif filtered_params[sort_order_key] && filtered_params[sort_order_key].value
      arr = filtered_params[sort_order_key].value.split('_leagues.')
      return "#{arr[0].capitalize}League" if arr.count > 1
    end
  end

  def preload_sources
    [:league]
  end

  def join_sources
    if league_type
      posts_table  = self.class.arel_table
      league_table = league_type.constantize.arel_table

      posts_table.join(league_table, Arel::Nodes::OuterJoin).on(
        league_table[:id].eq(posts_table[:league_id])
      ).join_sources
    end
  end
end