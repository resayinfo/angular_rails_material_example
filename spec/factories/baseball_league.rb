FactoryGirl.define do
  factory :baseball_league do
    teams { 2 + Random.rand(8) }
    teams_filled { Random.rand(2) }
    entry_fee { Random.rand(99999)/100.0 }
    draft_date { 1.month.from_now }
    name { Faker::Company.name }
    draft_type LeagueLike::SERPENTINE_ORDER
    draft_order { Faker::Lorem.sentence }
    url { "http://games.espn.go.com/flb/leaguesetup/settings?leagueId=#{Random.rand(999999)}" }
    seconds_per_draft_pick { 1 + Random.rand(89) }
    fractional_points { [true, false].sample }
    negative_points { [true, false].sample }
    trade_deadline { 3.months.from_now }
    playoff_weeks { 2 + Random.rand(4) }
    playoff_teams { 2 + Random.rand(4) }
    playoff_start_date { 7.months.from_now }
    waiver_rules 'Some good rules'
    starting_catchers { 2 + Random.rand(8) }
    max_catchers { 2 + Random.rand(8) }
    starting_first_basemen { 2 + Random.rand(8) }
    max_first_basemen { 2 + Random.rand(8) }
    starting_second_basemen { 2 + Random.rand(8) }
    max_second_basemen { 2 + Random.rand(8) }
    starting_third_basemen { 2 + Random.rand(8) }
    max_third_basemen { 2 + Random.rand(8) }
    starting_shortstops { 2 + Random.rand(8) }
    max_shortstops { 2 + Random.rand(8) }
    starting_left_fielders { 2 + Random.rand(8) }
    max_left_fielders { 2 + Random.rand(8) }
    starting_center_fielders { 2 + Random.rand(8) }
    max_center_fielders { 2 + Random.rand(8) }
    starting_right_fielders { 2 + Random.rand(8) }
    max_right_fielders { 2 + Random.rand(8) }
    starting_outfielders { 2 + Random.rand(8) }
    max_outfielders { 2 + Random.rand(8) }
    starting_utility_players { 2 + Random.rand(8) }
    max_utility_players { 2 + Random.rand(8) }
    starting_designated_hitters { 2 + Random.rand(8) }
    max_designated_hitters { 2 + Random.rand(8) }
    starting_pitchers { 2 + Random.rand(8) }
    max_pitchers { 2 + Random.rand(8) }
    starting_starting_pitchers { 2 + Random.rand(8) }
    max_starting_pitchers { 2 + Random.rand(8) }
    starting_relief_pitchers { 2 + Random.rand(8) }
    max_relief_pitchers { 2 + Random.rand(8) }
    bench_positions { 2 + Random.rand(8) }
    disabled_list_positions { 2 + Random.rand(8) }
    score_hits { [true, false].sample }
    score_extra_base_hits { [true, false].sample }
    score_batting_averages { [true, false].sample }
    score_slugging_percentage { [true, false].sample }
    score_on_base_percentage { [true, false].sample }
    score_total_bases { [true, false].sample }
    score_runs_created { [true, false].sample }
    score_singles { [true, false].sample }
    score_doubles { [true, false].sample }
    score_triples { [true, false].sample }
    score_homeruns { [true, false].sample }
    score_walks { [true, false].sample }
    score_runs_scored { [true, false].sample }
    score_runs_batted_in { [true, false].sample }
    score_stolen_bases { [true, false].sample }
    score_strikeouts { [true, false].sample }
    score_ground_into_double_plays { [true, false].sample }
    score_cycles { [true, false].sample }
    score_errors { [true, false].sample }
    score_earned_run_averages { [true, false].sample }
    score_whips { [true, false].sample }
    score_innings_pitched { [true, false].sample }
    score_earned_runs { [true, false].sample }
    score_wins { [true, false].sample }
    score_losses { [true, false].sample }
    score_saves { [true, false].sample }
    score_blown_saves { [true, false].sample }
    score_thrown_strikeouts { [true, false].sample }
    score_hits_allowed { [true, false].sample }
    score_walks_issued { [true, false].sample }
    score_shutouts { [true, false].sample }
    score_hit_batters { [true, false].sample }
    score_complete_games { [true, false].sample }
    score_no_hitters { [true, false].sample }
    score_perfect_games { [true, false].sample }
    score_on_base_percentages_against { [true, false].sample }
    score_batting_averages_against { [true, false].sample }
    score_strikeout_to_walk_ratios { [true, false].sample }
    score_strikeouts_per_9_innings { [true, false].sample }
    score_quality_starts { [true, false].sample }
  end
end