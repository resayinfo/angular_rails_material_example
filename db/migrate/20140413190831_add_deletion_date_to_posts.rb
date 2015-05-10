class AddDeletionDateToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.datetime :deleted_at
    end
  end
end
