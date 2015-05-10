class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :username, null: false, uniqueness: true
      t.string :email, null: false, uniqueness: true
      t.string :password_digest
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
