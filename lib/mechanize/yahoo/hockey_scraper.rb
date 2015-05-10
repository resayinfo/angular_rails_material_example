module Yahoo
  class HockeyScraper < Yahoo::Scraper

    URL = 'hockey.fantasysports.yahoo.com'
    LAST_WEEK_START_DATE = '30/3/2015'


    private
    def map_league_attributes!
      @league_attributes_map ||= {
        name:                        settings_value('League Name:'),
        teams:                       settings_value('Max Teams:').to_i,
        draft_date:                  iso8601_if_present(settings_value('Draft Time:')),
        draft_type:                  settings_value('Draft Type:'),
        fractional_points:           boolean_if_present(settings_value('Fractional Points:')),
        negative_points:             boolean_if_present(settings_value('Negative Points:')),
        trade_deadline:              iso8601_if_present(settings_value('Trade End Date:')),
        playoff_teams:               playoff_info[:teams].to_i,
        playoff_weeks:               scrape_playoff_weeks,
        playoff_start_date:          scrape_playoff_start_date.iso8601,
        waiver_rules:                scrape_waiver_rules('Waiver Time:', 'Waiver Type:', 'Waiver Mode:'),
        starting_centers:            position_count('C'),
        starting_right_wings:        position_count('RW'),
        starting_left_wings:         position_count('LW'),
        starting_defensemen:         position_count('D'),
        starting_goaltenders:        position_count('G'),
        starting_flex_wings:         position_count('W'),
        starting_flex_forwards:      position_count('F'),
        injured_reserve_positions:   position_count('IR|IR\+'),
        max_inactives:               position_count('NA'),
        utility_positions:           position_count('Util'),
        bench_positions:             position_count('BN'),
        score_goals:                 skater_category_present?('Goals \(G\)'),
        score_assists:               skater_category_present?('Assists \(A\)'),
        score_points:                skater_category_present?('Points \(P\)'),
        score_plus_minus:            skater_category_present?('Plus\/Minus \(\+\/\-\)'),
        score_penalty_minutes:       skater_category_present?('Penalty Minutes \(PIM\)'),
        score_powerplay_goals:       skater_category_present?('Powerplay Goals \(PPG\)'),
        score_powerplay_assists:     skater_category_present?('Powerplay Assists \(PPA\)'),
        score_powerplay_points:      skater_category_present?('Powerplay Points \(PPP\)'),
        score_shorthanded_goals:     skater_category_present?('Shorthanded Goals \(SHG\)'),
        score_shorthanded_points:    skater_category_present?('Shorthanded Points \(SHP\)'),
        score_shorthanded_assists:   skater_category_present?('Shorthanded Assists \(SHA\)'),
        score_game_winning_goals:    skater_category_present?('Game-Winning Goals \(GWG\)'),
        score_shots_on_goal:         skater_category_present?('Shots on Goal \(SOG\)'),
        score_shooting_percentage:   skater_category_present?('Shooting Percentage \(SH\%\)'),
        score_faceoffs_won:          skater_category_present?('Faceoffs Won \(FW\)'),
        score_faceoffs_lost:         skater_category_present?('Faceoffs Lost \(FL\)'),
        score_hits:                  skater_category_present?('Hits \(HIT\)'),
        score_blocks:                skater_category_present?('Blocks \(BLK\)'),
        score_games_started:         goalie_category_present?('Games Started \(GS\)'),
        score_wins:                  goalie_category_present?('Wins \(W\)'),
        score_losses:                goalie_category_present?('Losses \(L\)'),
        score_goals_against:         goalie_category_present?('Goals Against \(GA\)'),
        score_goals_against_average: goalie_category_present?('Goals Against Average \(GAA\)'),
        score_shots_against:         goalie_category_present?('Shots Against \(SA\)'),
        score_saves:                 goalie_category_present?('Saves \(SV\)'),
        score_save_percentage:       goalie_category_present?('Save Percentage \(SV\%\)'),
        score_shutouts:              goalie_category_present?('Shutouts \(SHO\)')
      }
    end

    def skater_scoring_categories
      @skater_scoring_categories ||= settings_value('Forwards/Defensemen Stat Categories:')
    end

    def goalie_scoring_categories
      @goalie_scoring_categories ||= settings_value('Goaltenders Stat Categories:')
    end

    def category_present?(all_categories, category)
      match_subpattern(all_categories, category).present?
    end

    def skater_category_present?(category)
      category_present?(skater_scoring_categories, category)
    end

    def goalie_category_present?(category)
      category_present?(goalie_scoring_categories, category)
    end
  end
end