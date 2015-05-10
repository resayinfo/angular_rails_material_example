class ChangeDraftDateType < ActiveRecord::Migration
  def change
    change_column :hockey_leagues, :draft_order, :text
    change_column :football_leagues, :draft_order, :text

    add_column :hockey_leagues, :draft_type, :string
    add_column :football_leagues, :draft_type, :string
  end
end
