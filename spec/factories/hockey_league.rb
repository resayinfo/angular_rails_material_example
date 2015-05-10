FactoryGirl.define do
  factory :hockey_league do
    teams { 2 + Random.rand(8) }
    teams_filled { Random.rand(2) }
    entry_fee { Random.rand(99999)/100.0 }
    draft_date { 1.month.from_now }
    name { Faker::Company.name }
    draft_type LeagueLike::SERPENTINE_ORDER
    draft_order { Faker::Lorem.sentence }
    url { "http://archive.fantasysports.yahoo.com/archive/nhl/2013/#{Random.rand(999999)}/settings" }
    seconds_per_draft_pick { 1 + Random.rand(89) }
    fractional_points { [true, false].sample }
    negative_points { [true, false].sample }
    trade_deadline { 3.months.from_now }
    playoff_weeks { 2 + Random.rand(4) }
    playoff_teams { 2 + Random.rand(4) }
    playoff_start_date { 7.months.from_now }
    waiver_rules 'Some good rules'
    starting_centers { 2 + Random.rand(8) }
    max_centers { 2 + Random.rand(8) }
    starting_right_wings { 2 + Random.rand(8) }
    max_right_wings { 2 + Random.rand(8) }
    starting_left_wings { 2 + Random.rand(8) }
    max_left_wings { 2 + Random.rand(8) }
    starting_defensemen { 2 + Random.rand(8) }
    max_defensemen { 2 + Random.rand(8) }
    starting_goaltenders { 2 + Random.rand(8) }
    max_goaltenders { 2 + Random.rand(8) }
    utility_positions { 2 + Random.rand(8) }
    bench_positions { 2 + Random.rand(8) }
    score_goals { [true, false].sample }
    score_assists { [true, false].sample }
    score_plus_minus { [true, false].sample }
    score_penalty_minutes { [true, false].sample }
    score_powerplay_points { [true, false].sample }
    score_shorthanded_goals { [true, false].sample }
    score_game_winning_goals { [true, false].sample }
    score_shots_on_goal { [true, false].sample }
    score_faceoffs_won { [true, false].sample }
    score_hits { [true, false].sample }
    score_wins { [true, false].sample }
    score_goals_against_average { [true, false].sample }
    score_saves { [true, false].sample }
    score_save_percentage { [true, false].sample }
    score_shutouts { [true, false].sample }
    score_points { [true, false].sample }
    score_powerplay_goals { [true, false].sample }
    score_powerplay_assists { [true, false].sample }
    score_shorthanded_points { [true, false].sample }
    score_shorthanded_assists { [true, false].sample }
    score_shooting_percentage { [true, false].sample }
    score_faceoffs_lost { [true, false].sample }
    score_blocks { [true, false].sample }
    score_games_started { [true, false].sample }
    score_losses { [true, false].sample }
    score_goals_against { [true, false].sample }
    score_shots_against { [true, false].sample }
    score_shifts { [true, false].sample }
    score_time_on_ice { [true, false].sample }
    score_average_time_on_ice { [true, false].sample }
    score_hat_tricks { [true, false].sample }
    score_defensemen_points { [true, false].sample }
    score_special_teams_goals { [true, false].sample }
    score_special_teams_assists { [true, false].sample }
    score_special_teams_points { [true, false].sample }
    score_empty_net_goals_against { [true, false].sample }
    score_minutes_played { [true, false].sample }
    score_overtime_losses { [true, false].sample }
    score_goalie_winning_percentage { [true, false].sample }
  end
end