FactoryGirl.define do
  factory :football_league do
    teams { 2 + Random.rand(8) }
    teams_filled { Random.rand(2) }
    entry_fee { Random.rand(99999)/100.0 }
    draft_date { 1.month.from_now }
    name { Faker::Company.name }
    draft_type LeagueLike::SERPENTINE_ORDER
    draft_order { Faker::Lorem.sentence }
    url 'http://archive.fantasysports.yahoo.com/archive/nfl/2013/285163/settings'
    seconds_per_draft_pick 90
    fractional_points { [true, false].sample }
    negative_points { [true, false].sample }
    trade_deadline { 3.months.from_now }
    playoff_weeks { 2 + Random.rand(4) }
    playoff_teams { 2 + Random.rand(4) }
    playoff_start_date { 7.months.from_now }
    waiver_rules 'Some good rules'
    starting_quarterbacks { 2 + Random.rand(8) }
    max_quarterbacks { 2 + Random.rand(8) }
    starting_wide_receivers { 2 + Random.rand(8) }
    max_wide_receivers { 2 + Random.rand(8) }
    starting_tight_ends { 2 + Random.rand(8) }
    max_tight_ends { 2 + Random.rand(8) }
    starting_running_backs { 2 + Random.rand(8) }
    max_running_backs { 2 + Random.rand(8) }
    starting_kickers { 2 + Random.rand(8) }
    max_kickers { 2 + Random.rand(8) }
    offensive_flex_positions { 2 + Random.rand(8) }
    starting_linebackers { 2 + Random.rand(8) }
    max_linebackers { 2 + Random.rand(8) }
    starting_defensive_backs { 2 + Random.rand(8) }
    max_defensive_backs { 2 + Random.rand(8) }
    starting_defensive_linemen { 2 + Random.rand(8) }
    max_defensive_linemen { 2 + Random.rand(8) }
    starting_defensive_teams { 2 + Random.rand(8) }
    max_defensive_teams { 2 + Random.rand(8) }
    defensive_flex_positions { 2 + Random.rand(8) }
    bench_positions { 2 + Random.rand(8) }
    points_per_passing_yard 0.04
    points_per_passing_td { 2 + Random.rand(8) }
    points_per_interception -2
    points_per_rushing_yard 0.1
    points_per_rushing_td { 2 + Random.rand(8) }
    points_per_reception { 2 + Random.rand(8) }
    points_per_reception_yard 0.1
    points_per_reception_td { 2 + Random.rand(8) }
    points_per_return_td { 2 + Random.rand(8) }
    points_per_2_point_conversion { 2 + Random.rand(8) }
    points_per_fumbles_lost -2
    points_per_offensive_fumble_return_td { 2 + Random.rand(8) }
    field_goal_point_range '3 to 7'
    field_goal_miss_point_range '-1 to -3'
    points_per_point_after { 2 + Random.rand(8) }
    points_per_point_after_miss -1
    points_per_defensive_sack 2
    points_per_defensive_interception { 2 + Random.rand(8) }
    points_per_fumble_recovery { 2 + Random.rand(8) }
    points_per_defensive_td { 2 + Random.rand(8) }
    points_per_safety { 2 + Random.rand(8) }
    points_per_block_kick { 2 + Random.rand(8) }
    points_per_kickoff_and_punt_return_td { 2 + Random.rand(8) }
    points_allowed_range '-7 to 10'
    injured_reserve_positions { 2 + Random.rand(8) }
    points_per_dst_sack { 2 + Random.rand(8) }
    points_per_dst_interception { 2 + Random.rand(8) }
    points_per_dst_fumble_recovery { 2 + Random.rand(8) }
    points_per_dst_td { 2 + Random.rand(8) }
    points_per_dst_safety { 2 + Random.rand(8) }
    points_per_dst_block_kick { 2 + Random.rand(8) }
    points_per_solo_tackle { 2 + Random.rand(8) }
    points_per_pass_defended { 2 + Random.rand(8) }
    points_per_tackle_assist { 2 + Random.rand(8) }
    points_per_fumble_forced { 2 + Random.rand(8) }
    points_per_dst_tackle_for_loss { 2 + Random.rand(8) }
    points_per_tackle_for_loss { 2 + Random.rand(8) }
    points_per_turnover_return_yard { 2 + Random.rand(8) }
  end
end
