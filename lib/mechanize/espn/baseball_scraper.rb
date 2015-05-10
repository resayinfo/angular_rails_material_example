module Espn
  class BaseballScraper < Espn::Scraper

    URL = 'games.espn.go.com/flb'
    LAST_WEEK_START_DATE = '????????????????????????????????'


    private
    def map_league_attributes!
      @league_attributes_map ||= {
        name:                              basic_settings_value('League Name'),
        teams:                             basic_settings_value('Number of Teams').to_i,
        draft_date:                        iso8601_if_present(draft_settings_value('Draft Date')),
        draft_type:                        draft_settings_value('Draft Type'),
        draft_order:                       draft_settings_value('Draft Order'),
        trade_deadline:                    iso8601_if_present(trade_deadline_with_year),
        seconds_per_draft_pick:            integer_if_present(draft_settings_value('Seconds Per Pick')),
        playoff_teams:                     playoff_info[:teams].to_i,
        playoff_weeks:                     scrape_playoff_weeks,
        playoff_start_date:                scrape_playoff_start_date.iso8601,
        waiver_rules:                      scrape_waiver_rules('Lineup Changes', 'Waiver Period', 'Waiver Process Days and Time', 'Waiver Order', 'Trade Limit', 'Trade Review Period', 'Votes Required to Veto Trade'),
        teams_filled:                      integer_if_present(''),
        entry_fee:                         decimal_value_present?(''),
        starting_catchers:                 integer_if_present(''),
        max_catchers:                      integer_if_present(''),
        starting_first_basemen:            integer_if_present(''),
        max_first_basemen:                 integer_if_present(''),
        starting_second_basemen:           integer_if_present(''),
        max_second_basemen:                integer_if_present(''),
        starting_third_basemen:            integer_if_present(''),
        max_third_basemen:                 integer_if_present(''),
        starting_shortstops:               integer_if_present(''),
        max_shortstops:                    integer_if_present(''),
        starting_left_fielders:            integer_if_present(''),
        max_left_fielders:                 integer_if_present(''),
        starting_center_fielders:          integer_if_present(''),
        max_center_fielders:               integer_if_present(''),
        starting_right_fielders:           integer_if_present(''),
        max_right_fielders:                integer_if_present(''),
        starting_outfielders:              integer_if_present(''),
        max_outfielders:                   integer_if_present(''),
        starting_utility_players:          integer_if_present(''),
        max_utility_players:               integer_if_present(''),
        starting_designated_hitters:       integer_if_present(''),
        max_designated_hitters:            integer_if_present(''),
        starting_pitchers:                 integer_if_present(''),
        max_pitchers:                      integer_if_present(''),
        starting_starting_pitchers:        integer_if_present(''),
        max_starting_pitchers:             integer_if_present(''),
        starting_relief_pitchers:          integer_if_present(''),
        max_relief_pitchers:               integer_if_present(''),
        bench_positions:                   integer_if_present(''),
        disabled_list_positions:           integer_if_present(''),
        score_hits:                        value_present?(''),
        score_extra_base_hits:             value_present?(''),
        score_batting_averages:            value_present?(''),
        score_slugging_percentage:         value_present?(''),
        score_on_base_percentage:          value_present?(''),
        score_total_bases:                 value_present?(''),
        score_runs_created:                value_present?(''),
        score_singles:                     value_present?(''),
        score_doubles:                     value_present?(''),
        score_triples:                     value_present?(''),
        score_homeruns:                    value_present?(''),
        score_walks:                       value_present?(''),
        score_runs_scored:                 value_present?(''),
        score_runs_batted_in:              value_present?(''),
        score_stolen_bases:                value_present?(''),
        score_strikeouts:                  value_present?(''),
        score_ground_into_double_plays:    value_present?(''),
        score_cycles:                      value_present?(''),
        score_errors:                      value_present?(''),
        score_earned_run_averages:         value_present?(''),
        score_whips:                       value_present?(''),
        score_innings_pitched:             value_present?(''),
        score_earned_runs:                 value_present?(''),
        score_wins:                        value_present?(''),
        score_losses:                      value_present?(''),
        score_saves:                       value_present?(''),
        score_blown_saves:                 value_present?(''),
        score_thrown_strikeouts:           value_present?(''),
        score_hits_allowed:                value_present?(''),
        score_walks_issued:                value_present?(''),
        score_shutouts:                    value_present?(''),
        score_hit_batters:                 value_present?(''),
        score_complete_games:              value_present?(''),
        score_no_hitters:                  value_present?(''),
        score_perfect_games:               value_present?(''),
        score_on_base_percentages_against: value_present?(''),
        score_batting_averages_against:    value_present?(''),
        score_strikeout_to_walk_ratios:    value_present?(''),
        score_strikeouts_per_9_innings:    value_present?(''),
        score_quality_starts:              value_present?(''),
        negative_points:                   true,
        fractional_points:                 true
      }
    end

    def validate_page!
      super

      unless basic_settings_value('Scoring Type') == 'Head to Head Each Category'
        raise LeagueScraper::ScoringTypeError, "scoring type must be 'Head to Head Each Category' for #{self.class.readable_league_type}"
      end
    end
  end
end