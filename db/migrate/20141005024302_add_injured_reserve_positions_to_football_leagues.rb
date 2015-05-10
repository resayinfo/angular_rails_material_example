class AddInjuredReservePositionsToFootballLeagues < ActiveRecord::Migration
  def change
    add_column :football_leagues, :injured_reserve_positions, :integer
  end
end
