require 'spec_helper'

describe Yahoo::HockeyScraper, :vcr do
  describe '.scrape_league_attributes!' do
    let(:url){ 'http://hockey.fantasysports.yahoo.com/hockey/87444/settings' }
    let(:scrape_results){ Yahoo::HockeyScraper.scrape_league_attributes!(url) }
    let(:expected_results) do
      {
        name: "FantasyLeagueFinder",
        teams: 12,
        teams_filled: nil,
        entry_fee: nil,
        draft_date: DateTime.strptime('16/11 11:45pm PST', "%d/%m %I:%M%p %Z").iso8601,
        draft_type: "Live Standard Draft",
        trade_deadline: DateTime.parse('5/3/2015').iso8601,
        playoff_teams: 6,
        playoff_weeks: 3,
        playoff_start_date: DateTime.parse('9/3/2015').iso8601,
        waiver_rules: "Waiver Time: 2 days, Waiver Type: Continual rolling list, Waiver Mode: Standard",
        starting_centers: 2,
        starting_right_wings: 2,
        starting_left_wings: 2,
        starting_defensemen: 4,
        starting_goaltenders: 2,
        starting_flex_wings: 1,
        starting_flex_forwards: 2,
        injured_reserve_positions: 3,
        max_inactives: 1,
        utility_positions: 1,
        bench_positions: 2,
        score_goals: true,
        score_assists: true,
        score_points: true,
        score_plus_minus: true,
        score_penalty_minutes: true,
        score_powerplay_goals: true,
        score_powerplay_assists: true,
        score_powerplay_points: false,
        score_shorthanded_goals: true,
        score_shorthanded_points: false,
        score_shorthanded_assists: true,
        score_game_winning_goals: true,
        score_shots_on_goal: true,
        score_shooting_percentage: true,
        score_faceoffs_won: true,
        score_faceoffs_lost: false,
        score_hits: true,
        score_blocks: true,
        score_games_started: true,
        score_wins: true,
        score_losses: true,
        score_goals_against: true,
        score_goals_against_average: true,
        score_shots_against: true,
        score_saves: true,
        score_save_percentage: true,
        score_shutouts: true,
        draft_order: nil,
        fractional_points: nil,
        negative_points: nil,
        seconds_per_draft_pick: nil,
        max_centers: nil,
        max_defensemen: nil,
        max_goaltenders: nil,
        max_left_wings: nil,
        max_right_wings: nil,
        score_shifts: false,
        score_time_on_ice: false,
        score_average_time_on_ice: false,
        score_hat_tricks: false,
        score_defensemen_points: false,
        score_special_teams_goals: false,
        score_special_teams_assists: false,
        score_special_teams_points: false,
        score_empty_net_goals_against: false,
        score_minutes_played: false,
        score_overtime_losses: false,
        score_goalie_winning_percentage: false,
        scraped_league_type: 'Yahoo Hockey',
        url: url
      }
    end

    it "gets all of the settings from the url" do
      expect(scrape_results).to eq(expected_results)
    end
  end
end