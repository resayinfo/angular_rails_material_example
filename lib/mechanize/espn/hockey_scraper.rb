module Espn
  class HockeyScraper < Espn::Scraper

    URL = 'games.espn.go.com/fhl'
    LAST_WEEK_START_DATE = '23/3/2015'


    private
    def map_league_attributes!
      @league_attributes_map ||= {
        name:                            basic_settings_value('League Name'),
        teams:                           basic_settings_value('Number of Teams').to_i,
        draft_date:                      iso8601_if_present(draft_settings_value('Draft Date')),
        draft_type:                      draft_settings_value('Draft Type'),
        draft_order:                     draft_settings_value('Draft Order'),
        trade_deadline:                  iso8601_if_present(trade_deadline_with_year),
        seconds_per_draft_pick:          integer_if_present(draft_settings_value('Seconds Per Pick')),
        playoff_teams:                   playoff_info[:teams].to_i,
        playoff_weeks:                   scrape_playoff_weeks,
        playoff_start_date:              scrape_playoff_start_date.iso8601,
        waiver_rules:                    scrape_waiver_rules('Lineup Changes', 'Waiver Period', 'Waiver Process Days and Time', 'Waiver Order', 'Trade Limit', 'Trade Review Period', 'Votes Required to Veto Trade'),
        starting_centers:                integer_if_present(roster_value('Center (C)')),
        starting_right_wings:            integer_if_present(roster_value('Right Wing (RW)')),
        starting_left_wings:             integer_if_present(roster_value('Left Wing (LW)')),
        starting_defensemen:             integer_if_present(roster_value('Defense (D)')),
        starting_goaltenders:            integer_if_present(roster_value('Goalie (G)')),
        starting_flex_forwards:          integer_if_present(roster_value('Forward (F)')),
        injured_reserve_positions:       integer_if_present(roster_value('Injured Reserve (IR)')),
        utility_positions:               integer_if_present(roster_value('Utility (UTIL)')),
        bench_positions:                 integer_if_present(roster_value('Bench (BE)')),
        score_goals:                     skater_category_present?('Goals (G)'),
        score_assists:                   skater_category_present?('Assists (A)'),
        score_points:                    skater_category_present?('Points (PTS)'),
        score_plus_minus:                skater_category_present?('Plus/minus (+/-)'),
        score_penalty_minutes:           skater_category_present?('Penalty Minutes (PIM)'),
        score_powerplay_goals:           skater_category_present?('Power Play Goals (PPG)'),
        score_powerplay_assists:         skater_category_present?('Power Play Assists (PPA)'),
        score_powerplay_points:          skater_category_present?('Power Play Points (PPP)'),
        score_shorthanded_goals:         skater_category_present?('Short Handed Goals (SHG)'),
        score_shorthanded_points:        skater_category_present?('Short Handed Points (SHP)'),
        score_shorthanded_assists:       skater_category_present?('Short Handed Assists (SHA)'),
        score_game_winning_goals:        skater_category_present?('Game-Winning Goals (GWG)'),
        score_shots_on_goal:             skater_category_present?('Shots on goal (SOG)'),
        score_faceoffs_won:              skater_category_present?('Faceoffs Won (FOW)'),
        score_faceoffs_lost:             skater_category_present?('Faceoffs Lost (FOL)'),
        score_hits:                      skater_category_present?('Hits (HIT)'),
        score_blocks:                    skater_category_present?('Blocked Shots (BLK)'),
        score_games_started:             goalie_category_present?('Games Started (GS)'),
        score_wins:                      goalie_category_present?('Wins (W)'),
        score_losses:                    goalie_category_present?('Losses (L)*'),
        score_goals_against:             goalie_category_present?('Goals Against (GA)*'),
        score_goals_against_average:     goalie_category_present?('Goals Against Average (GAA)*'),
        score_shots_against:             goalie_category_present?('Shots Against (SA)'),
        score_saves:                     goalie_category_present?('Saves (SV)'),
        score_save_percentage:           goalie_category_present?('Save Percentage (SV%)*'),
        score_shutouts:                  goalie_category_present?('Shutouts (SO)'),
        score_shifts:                    skater_category_present?('Shifts (SHFT)'),
        score_time_on_ice:               skater_category_present?('Time on Ice (TOI)'),
        score_average_time_on_ice:       skater_category_present?('Average Time on Ice (ATOI)'),
        score_hat_tricks:                skater_category_present?('Hat Tricks (HAT)'),
        score_defensemen_points:         skater_category_present?('Defensemen Points (DEF)'),
        score_special_teams_goals:       skater_category_present?('Special Teams Goals (STG)'),
        score_special_teams_assists:     skater_category_present?('Special Teams Assists (STA)'),
        score_special_teams_points:      skater_category_present?('Special Teams Points (STP)'),
        score_empty_net_goals_against:   goalie_category_present?('Empty Net Goals Against (EGA)*'),
        score_minutes_played:            goalie_category_present?('Minutes Played (MIN)'),
        score_overtime_losses:           goalie_category_present?('Overtime Losses (OTL)*'),
        score_goalie_winning_percentage: goalie_category_present?('Goalie Winning Percentage (GW%)*'),
        negative_points:                 true,
        fractional_points:               true
      }
    end

    def validate_page!
      super

      unless basic_settings_value('Scoring Type') == 'Head to Head Each Category'
        raise LeagueScraper::ScoringTypeError, "scoring type must be 'Head to Head Each Category' for #{self.class.readable_league_type}"
      end
    end

    def page_present?
      basic_settings_hash.present?
    end

    def basic_settings_hash
      @basic_settings_hash ||= hashify_child_tables page.at("div[name='basic']")
    end

    def basic_settings_value(field_name)
      basic_settings_hash[field_name]
    end

    def rules_hash
      @rules_hash ||= hashify_child_tables page.at("div[name='rules']")
    end

    def rules_value(field_name)
      rules_hash[field_name]
    end

    def roster_hash
      @roster_hash ||= hashify_child_tables page.at("div[name='roster'] tr.rowOdd").children[1]
    end

    def roster_value(field_name)
      roster_hash[field_name]
    end

    def season_settings_hash
      @season_settings_hash ||= hashify_child_tables page.at("div.regularSeasonSettings")
    end

    def season_settings_value(field_name)
      season_settings_hash[field_name]
    end

    def playoff_settings_hash
      @playoff_settings_hash ||= hashify_child_tables page.at("div.playoffSettings")
    end

    def playoff_settings_value(field_name)
      playoff_settings_hash[field_name]
    end

    def draft_settings_hash
      @draft_settings_hash ||= hashify_child_tables page.at("div[name='draft']")
    end

    def draft_settings_value(field_name)
      draft_settings_hash[field_name]
    end

    def skater_scoring_categories
      @skater_scoring_categories ||= scoring_table_row false
    end

    def goalie_scoring_categories
      @goalie_scoring_categories ||= scoring_table_row true
    end

    def skater_category_present?(category)
      category_present?(skater_scoring_categories, category)
    end

    def goalie_category_present?(category)
      category_present?(goalie_scoring_categories, category)
    end

    def scoring_table_row(even)
      even_odd = even ? 'Even' : 'Odd'

      position_table = hashify_child_tables page.at("div[name='scoring'] tr.row#{even_odd}").children[1], 2
      Set[*position_table.flatten]
    end

    def trade_deadline_with_year
      @trade_deadline_with_year ||= begin
        return nil unless value = rules_value('Trade Deadline')
        value << ', 2015'
      end
    end

    def category_present?(all_categories, category)
      all_categories.include? category
    end

    def hashify_child_tables(node, value_index=1)
      return {} unless node

      parsed_tables = []

      node.children.each do |t|
        next if t.name != 'table'
        parsed_tables += t.children.map do |row|
          td = row.children
          next unless value = td[value_index]
          [td[0].text.strip, value.text.strip]
        end.compact
      end

      Hash[parsed_tables]
    end
  end
end