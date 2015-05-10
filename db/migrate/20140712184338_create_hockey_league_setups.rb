class CreateHockeyLeagueSetups < ActiveRecord::Migration
  def change
    rename_table :football_league_setups, :football_leagues
    rename_column :football_leagues, :league_name, :name
    change_column :football_leagues, :name, :string, null: false
    change_column :football_leagues, :fractional_points, :boolean, null: false, default: false
    change_column :football_leagues, :negative_points, :boolean, null: false, default: false

    create_table :hockey_leagues do |t|
      t.string :name, null: false
      t.integer :teams
      t.datetime :draft_date
      t.datetime :draft_order
      t.integer :seconds_per_draft_pick
      t.boolean :fractional_points, null: false, default: false
      t.boolean :negative_points, null: false, default: false
      t.datetime :trade_deadline
      t.integer :playoff_teams
      t.integer :playoff_weeks
      t.datetime :playoff_start_date
      t.string :waiver_rules
      t.string :url
      t.integer :starting_centers
      t.integer :total_centers
      t.integer :starting_right_wings
      t.integer :total_right_wings
      t.integer :starting_left_wings
      t.integer :total_left_wings
      t.integer :starting_defensemen
      t.integer :total_defensemen
      t.integer :starting_goaltenders
      t.integer :total_goaltenders
      t.integer :utility_positions
      t.integer :bench_positions
      t.boolean :score_goals, null: false, default: false
      t.boolean :score_assists, null: false, default: false
      t.boolean :score_plus_minus, null: false, default: false
      t.boolean :score_penalty_minutes, null: false, default: false
      t.boolean :score_powerplay_points, null: false, default: false
      t.boolean :score_shorthanded_goals, null: false, default: false
      t.boolean :score_game_winning_goals, null: false, default: false
      t.boolean :score_shots_on_goal, null: false, default: false
      t.boolean :score_faceoffs_won, null: false, default: false
      t.boolean :score_hits, null: false, default: false
      t.boolean :score_wins, null: false, default: false
      t.boolean :score_goals_against_average, null: false, default: false
      t.boolean :score_saves, null: false, default: false
      t.boolean :score_save_percentage, null: false, default: false
      t.boolean :score_shutouts, null: false, default: false
      t.timestamps
    end

    remove_reference :posts, :league_setup
    remove_column :posts, :league_setup_type
    add_reference :posts, :league, polymorphic: true, index: true
  end
end
