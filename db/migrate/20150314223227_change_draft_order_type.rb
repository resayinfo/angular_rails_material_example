class ChangeDraftOrderType < ActiveRecord::Migration
  def change
    change_column :hockey_leagues, :draft_order, :string
    change_column :football_leagues, :draft_order, :string
  end
end
