module Yahoo
  class FootballScraper < Yahoo::Scraper

    URL                      = 'football.fantasysports.yahoo.com'
    LAST_WEEK_START_DATE     = '23/12/2014'


    private
    def map_league_attributes!
      @league_attributes_map ||= {
        name:                                  settings_value('League Name:'),
        teams:                                 settings_value('Max Teams:').to_i,
        draft_date:                            iso8601_if_present(settings_value('Draft Time:')),
        draft_type:                            settings_value('Draft Type:'),
        fractional_points:                     boolean_if_present(settings_value('Fractional Points:')),
        negative_points:                       boolean_if_present(settings_value('Negative Points:')),
        trade_deadline:                        iso8601_if_present(settings_value('Trade End Date:')),
        playoff_teams:                         playoff_info[:teams].to_i,
        playoff_weeks:                         scrape_playoff_weeks,
        playoff_start_date:                    scrape_playoff_start_date.iso8601,
        waiver_rules:                          scrape_waiver_rules('Waiver Time:', 'Waiver Type:', 'Weekly Waivers'),
        starting_quarterbacks:                 position_count('QB'),
        starting_wide_receivers:               position_count('WR'),
        starting_tight_ends:                   position_count('TE'),
        starting_running_backs:                position_count('RB'),
        starting_kickers:                      position_count('K'),
        offensive_flex_positions:              position_count('(\w\/)+\w'),
        starting_linebackers:                  position_count('LB'),
        starting_defensive_backs:              position_count('S|CB'),
        starting_defensive_linemen:            position_count('DT|DE|DL'),
        starting_defensive_teams:              position_count('DEF'),
        defensive_flex_positions:              position_count('D'),
        bench_positions:                       position_count('BN'),
        points_per_passing_yard:               inverse_if_present(offensive_stats_value('Passing Yards')),
        points_per_passing_td:                 float_if_present(offensive_stats_value('Passing Touchdowns')),
        points_per_interception:               float_if_present(offensive_stats_value('Interceptions')),
        points_per_rushing_yard:               inverse_if_present(offensive_stats_value('Rushing Yards')),
        points_per_rushing_td:                 float_if_present(offensive_stats_value('Rushing Touchdowns')),
        points_per_reception:                  float_if_present(offensive_stats_value('ReceptionsYahoo Default')),
        points_per_reception_yard:             inverse_if_present(offensive_stats_value('Reception Yards')),
        points_per_reception_td:               float_if_present(offensive_stats_value('Reception Touchdowns')),
        points_per_return_td:                  float_if_present(offensive_stats_value('Return Touchdowns')),
        points_per_2_point_conversion:         float_if_present(offensive_stats_value('2-Point Conversions')),
        points_per_fumbles_lost:               float_if_present(offensive_stats_value('Fumbles Lost')),
        points_per_offensive_fumble_return_td: float_if_present(offensive_stats_value('Offensive Fumble Return TD')),
        points_per_point_after:                float_if_present(kickers_stats_value('Point After Attempt Made')),
        points_per_point_after_miss:           float_if_present(kickers_stats_value('Point After Attempt Missed')),
        points_per_defensive_sack:             float_if_present(defensive_stats_value('Sack')),
        points_per_defensive_interception:     float_if_present(defensive_stats_value('Interception')),
        points_per_fumble_recovery:            float_if_present(defensive_stats_value('Fumble Recovery')),
        points_per_defensive_td:               float_if_present(defensive_stats_value('Defensive TouchdownYahoo Default')),
        points_per_safety:                     float_if_present(defensive_stats_value('SafetyYahoo Default')),
        points_per_block_kick:                 float_if_present(defensive_stats_value('Block KickYahoo Default')),
        points_per_kickoff_and_punt_return_td: float_if_present(dst_stats_value('Kickoff and Punt Return Touchdowns')),
        points_per_dst_sack:                   float_if_present(dst_stats_value('Sack')),
        points_per_dst_interception:           float_if_present(dst_stats_value('Interception')),
        points_per_dst_fumble_recovery:        float_if_present(dst_stats_value('Fumble RecoveryYahoo Default')),
        points_per_dst_td:                     float_if_present(dst_stats_value('TouchdownYahoo Default')),
        points_per_dst_safety:                 float_if_present(dst_stats_value('Safety')),
        points_per_dst_block_kick:             float_if_present(dst_stats_value('Block Kick')),
        points_per_solo_tackle:                float_if_present(defensive_stats_value('Tackle Solo')),
        points_per_pass_defended:              float_if_present(defensive_stats_value('Pass DefendedYahoo Default')),
        points_per_tackle_assist:              float_if_present(defensive_stats_value('Tackle Assist')),
        points_per_fumble_forced:              float_if_present(defensive_stats_value('Fumble Force')),
        points_per_dst_tackle_for_loss:        float_if_present(dst_stats_value('Tackles for Loss')),
        points_per_tackle_for_loss:            float_if_present(defensive_stats_value('Tackles for LossYahoo Default')),
        points_per_turnover_return_yard:       inverse_if_present(defensive_stats_value('Turnover Return Yards')),
        injured_reserve_positions:             position_count('IR'),
        field_goal_miss_point_range:           scrape_field_goal_miss_point_range,
        field_goal_point_range:                scrape_field_goal_point_range,
        points_allowed_range:                  scrape_points_allowed_range
      }
    end

    def scrape_field_goal_point_range
      @scrape_field_goal_point_range ||= kicker_range_string(
        'Field Goals 0-19 Yards',
        'Field Goals 20-29 Yards',
        'Field Goals 30-39 Yards',
        'Field Goals 40-49 Yards',
        'Field Goals 50+ Yards'
      )
    end

    def scrape_field_goal_miss_point_range
      @scrape_field_goal_miss_point_range ||= kicker_range_string(
        'Field Goals Missed 0-19 Yards',
        'Field Goals Missed 20-29 Yards',
        'Field Goals Missed 30-39 Yards',
        'Field Goals Missed 40-49 Yards',
        'Field Goals Missed 50+ Yards'
      )
    end

    def scrape_points_allowed_range
      @scrape_points_allowed_range ||= dst_range_string(
        'Points Allowed 0 points',
        'Points Allowed 1-6 points',
        'Points Allowed 7-13 points',
        'Points Allowed 14-20 points',
        'Points Allowed 21-27 points',
        'Points Allowed 28-34 points',
        'Points Allowed 35+ points'
      )
    end

    def offensive_stats_value(field_name)
      stats_subtable_value(offensive_stats_table, field_name)
    end

    def defensive_stats_value(field_name)
      stats_subtable_value(defensive_stats_table, field_name)
    end

    def dst_stats_value(field_name)
      stats_subtable_value(dst_stats_table, field_name)
    end

    def kickers_stats_value(field_name)
      stats_subtable_value(kickers_stats_table, field_name)
    end

    def offensive_stats_table
      @offensive_stats_table ||= stats_subtable_hash 'Offense'
    end

    def kickers_stats_table
      @kickers_stats_table ||= stats_subtable_hash 'Kickers'
    end

    def dst_stats_table
      @dst_stats_table ||= stats_subtable_hash 'Defense/Special Teams'
    end

    def defensive_stats_table
      @defensive_stats_table ||= stats_subtable_hash 'Defensive Players'
    end

    def stats_table
      @stats_table ||= page.at('#settings-stat-mod-table')
    end

    def stats_subtable_hash(table_name)
      node = stats_table.at("./thead/tr/th[contains(text(),'#{table_name}')]/../..").next
      node = node.next if table_offset == 1
      hashify_table_body node
    end

    def stats_subtable_value(subtable_hash, field_name)
      subtable_hash[field_name]
    end

    def last_week_counts?
      playoff_info[:weeks][-1] == '17'
    end

    def kicker_range_string(*field_names)
      stats_range_string field_names, 'distance', 'kickers_stats_value'
    end

    def dst_range_string(*field_names)
      stats_range_string field_names, 'amount', 'dst_stats_value'
    end

    def stats_range_string(field_names, value_type, scraper_method)
      values = field_names.map do |n|
        float_if_present send(scraper_method, n)
      end

      values = values.uniq.compact.sort
      if values.count == 1
        "#{values[0]} for any #{value_type}"
      elsif values.count > 1
        "#{values[0]} to #{values[-1]}"
      end
    end
  end
end