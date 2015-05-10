class AddTeamsFilledAndBuyIn < ActiveRecord::Migration
  def change
    add_column :football_leagues, :teams_filled, :integer
    add_column :hockey_leagues, :teams_filled, :integer
    add_column :football_leagues, :entry_fee, :decimal, precision: 10, scale: 2
    add_column :hockey_leagues, :entry_fee, :decimal, precision: 10, scale: 2
  end
end
