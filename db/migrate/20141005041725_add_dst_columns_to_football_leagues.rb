class AddDstColumnsToFootballLeagues < ActiveRecord::Migration
  def change
    change_table :football_leagues do |t|
      t.decimal :points_per_dst_sack, precision: 6, scale: 3
      t.decimal :points_per_dst_interception, precision: 6, scale: 3
      t.decimal :points_per_dst_fumble_recovery, precision: 6, scale: 3
      t.decimal :points_per_dst_td, precision: 6, scale: 3
      t.decimal :points_per_dst_safety, precision: 6, scale: 3
      t.decimal :points_per_dst_block_kick, precision: 6, scale: 3
      t.decimal :points_per_solo_tackle, precision: 6, scale: 3
      t.decimal :points_per_pass_defended, precision: 6, scale: 3
      t.decimal :points_per_tackle_assist, precision: 6, scale: 3
      t.decimal :points_per_fumble_forced, precision: 6, scale: 3
      t.decimal :points_per_dst_tackle_for_loss, precision: 6, scale: 3
      t.decimal :points_per_tackle_for_loss, precision: 6, scale: 3
      t.decimal :points_per_turnover_return_yard, precision: 6, scale: 3
    end
  end
end
