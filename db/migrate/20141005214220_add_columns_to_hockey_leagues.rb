class AddColumnsToHockeyLeagues < ActiveRecord::Migration
  def change
    change_table :hockey_leagues do |t|
      t.integer :starting_flex_wings
      t.integer :starting_flex_forwards
      t.integer :injured_reserve_positions
      t.integer :total_inactives
      t.boolean :score_points, null: false, default: false
      t.boolean :score_powerplay_goals, null: false, default: false
      t.boolean :score_powerplay_assists, null: false, default: false
      t.boolean :score_shorthanded_points, null: false, default: false
      t.boolean :score_shorthanded_assists, null: false, default: false
      t.boolean :score_shooting_percentage, null: false, default: false
      t.boolean :score_faceoffs_lost, null: false, default: false
      t.boolean :score_blocks, null: false, default: false
      t.boolean :score_games_started, null: false, default: false
      t.boolean :score_losses, null: false, default: false
      t.boolean :score_goals_against, null: false, default: false
      t.boolean :score_shots_against, null: false, default: false
    end
  end
end
