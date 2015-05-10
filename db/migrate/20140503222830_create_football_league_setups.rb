class CreateFootballLeagueSetups < ActiveRecord::Migration
  def change
    create_table :football_league_setups do |t|
      t.string :league_name
      t.integer :teams
      t.datetime :draft_date
      t.datetime :draft_order
      t.integer :seconds_per_draft_pick
      t.boolean :fractional_points
      t.boolean :negative_points
      t.datetime :trade_deadline
      t.integer :playoff_teams
      t.integer :playoff_weeks
      t.datetime :playoff_start_date
      t.string :waiver_rules
      t.integer :starting_quarterbacks
      t.integer :total_quarterbacks
      t.integer :starting_wide_receivers
      t.integer :total_wide_receivers
      t.integer :starting_tight_ends
      t.integer :total_tight_ends
      t.integer :starting_running_backs
      t.integer :total_running_backs
      t.integer :starting_kickers
      t.integer :total_kickers
      t.integer :offensive_flex_positions
      t.integer :starting_linebackers
      t.integer :total_linebackers
      t.integer :starting_defensive_backs
      t.integer :total_defensive_backs
      t.integer :starting_defensive_linemen
      t.integer :total_defensive_linemen
      t.integer :starting_linebackers
      t.integer :total_linebackers
      t.integer :starting_defensive_teams
      t.integer :total_defensive_teams
      t.integer :defensive_flex_positions
      t.integer :bench_positions
      t.decimal :points_per_passing_yard, precision: 6, scale: 3
      t.decimal :points_per_passing_td, precision: 6, scale: 3
      t.decimal :points_per_interception, precision: 6, scale: 3
      t.decimal :points_per_rushing_yard, precision: 6, scale: 3
      t.decimal :points_per_rushing_td, precision: 6, scale: 3
      t.decimal :points_per_reception, precision: 6, scale: 3
      t.decimal :points_per_reception_yard, precision: 6, scale: 3
      t.decimal :points_per_reception_td, precision: 6, scale: 3
      t.decimal :points_per_return_td, precision: 6, scale: 3
      t.decimal :points_per_2_point_conversion, precision: 6, scale: 3
      t.decimal :points_per_fumbles_lost, precision: 6, scale: 3
      t.decimal :points_per_offensive_fumble_return_td, precision: 6, scale: 3
      t.string  :field_goal_point_range
      t.string  :field_goal_miss_point_range
      t.decimal :points_per_point_after, precision: 6, scale: 3
      t.decimal :points_per_point_after_miss, precision: 6, scale: 3
      t.decimal :points_per_defensive_sack, precision: 6, scale: 3
      t.decimal :points_per_defensive_interception, precision: 6, scale: 3
      t.decimal :points_per_fumble_recovery, precision: 6, scale: 3
      t.decimal :points_per_defensive_td, precision: 6, scale: 3
      t.decimal :points_per_safety, precision: 6, scale: 3
      t.decimal :points_per_block_kick, precision: 6, scale: 3
      t.decimal :points_per_kickoff_and_punt_return_td, precision: 6, scale: 3
      t.string :points_allowed_range

      t.timestamps
    end

    add_reference :posts, :league_setup, polymorphic: true, index: true
  end
end
