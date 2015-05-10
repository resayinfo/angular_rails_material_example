class AddUrlToFootballLeagueSetups < ActiveRecord::Migration
  def change
    add_column :football_league_setups, :url, :string
  end
end
