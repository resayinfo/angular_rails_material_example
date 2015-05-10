class ChangeLeagueColumns < ActiveRecord::Migration
  def change
    rename_column :hockey_leagues, :total_centers, :max_centers
    rename_column :hockey_leagues, :total_right_wings, :max_right_wings
    rename_column :hockey_leagues, :total_left_wings, :max_left_wings
    rename_column :hockey_leagues, :total_defensemen, :max_defensemen
    rename_column :hockey_leagues, :total_goaltenders, :max_goaltenders
    rename_column :hockey_leagues, :total_inactives, :max_inactives

    rename_column :football_leagues, :total_quarterbacks, :max_quarterbacks
    rename_column :football_leagues, :total_wide_receivers, :max_wide_receivers
    rename_column :football_leagues, :total_tight_ends, :max_tight_ends
    rename_column :football_leagues, :total_running_backs, :max_running_backs
    rename_column :football_leagues, :total_kickers, :max_kickers
    rename_column :football_leagues, :total_linebackers, :max_linebackers
    rename_column :football_leagues, :total_defensive_backs, :max_defensive_backs
    rename_column :football_leagues, :total_defensive_linemen, :max_defensive_linemen
    rename_column :football_leagues, :total_defensive_teams, :max_defensive_teams

    change_table :hockey_leagues do |t|
      t.boolean :score_shifts, null: false, default: false
      t.boolean :score_time_on_ice, null: false, default: false
      t.boolean :score_average_time_on_ice, null: false, default: false
      t.boolean :score_hat_tricks, null: false, default: false
      t.boolean :score_defensemen_points, null: false, default: false
      t.boolean :score_special_teams_goals, null: false, default: false
      t.boolean :score_special_teams_assists, null: false, default: false
      t.boolean :score_special_teams_points, null: false, default: false
      t.boolean :score_empty_net_goals_against, null: false, default: false
      t.boolean :score_minutes_played, null: false, default: false
      t.boolean :score_overtime_losses, null: false, default: false
      t.boolean :score_goalie_winning_percentage, null: false, default: false
    end
  end
end