require 'spec_helper'

describe Espn::HockeyScraper, :vcr do
  describe '.scrape_league_attributes!' do
    let(:url){ 'http://games.espn.go.com/fhl/leaguesetup/settings?leagueId=81155' }
    let(:scrape_results){ Espn::HockeyScraper.scrape_league_attributes!(url) }
    let(:expected_results) do
      {
        name: "Fantasy League Finder",
        teams: 10,
        teams_filled: nil,
        entry_fee: nil,
        draft_date: DateTime.parse('22/10/2014 11:45pm').iso8601,
        draft_type: "Snake",
        draft_order: "Manually Set by League Manager",
        seconds_per_draft_pick: 90,
        fractional_points: true,
        trade_deadline: DateTime.parse('25/2/2015 12:00pm').iso8601,
        playoff_teams: 4,
        playoff_weeks: 2,
        playoff_start_date: DateTime.parse('9/3/2015').iso8601,
        waiver_rules: "Lineup Changes: Daily - Lock Individually at Scheduled Gametime, Waiver Period: 1 Day, Waiver Process Days and Time: Sunday at 11 AM, Waiver Order: Move to Last After Claim, Never Reset Order, Trade Limit: No Limit, Trade Review Period: 2 Days, Votes Required to Veto Trade: 4",
        starting_centers: 2,
        starting_right_wings: 2,
        starting_left_wings: 2,
        starting_defensemen: 4,
        starting_goaltenders: 2,
        starting_flex_forwards: 2,
        starting_flex_wings: nil,
        injured_reserve_positions: 3,
        utility_positions: 1,
        bench_positions: 2,
        score_goals: false,
        score_assists: true,
        score_points: true,
        score_plus_minus: true,
        score_penalty_minutes: true,
        score_powerplay_goals: true,
        score_powerplay_assists: true,
        score_powerplay_points: false,
        score_shorthanded_goals: true,
        score_shorthanded_assists: true,
        score_shorthanded_points: false,
        score_game_winning_goals: true,
        score_shots_on_goal: true,
        score_faceoffs_won: true,
        score_faceoffs_lost: true,
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
        score_shifts: true,
        score_time_on_ice: true,
        score_average_time_on_ice: true,
        score_hat_tricks: true,
        score_defensemen_points: true,
        score_special_teams_goals: true,
        score_special_teams_assists: true,
        score_special_teams_points: true,
        score_empty_net_goals_against: true,
        score_minutes_played: true,
        score_overtime_losses: true,
        score_goalie_winning_percentage: true,
        max_centers: nil,
        max_defensemen: nil,
        max_goaltenders: nil,
        max_inactives: nil,
        max_left_wings: nil,
        max_right_wings: nil,
        negative_points: true,
        score_shooting_percentage: false,
        scraped_league_type: 'Espn Hockey',
        url: url
      }
    end

    it "gets all of the settings from the url" do
      expect(scrape_results).to eq(expected_results)
    end
  end
end