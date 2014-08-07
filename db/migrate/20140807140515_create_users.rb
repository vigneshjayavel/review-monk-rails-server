class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :description
      t.integer :device_id
      t.decimal :gps_latitude
      t.decimal :gps_longitude

      t.timestamps
    end
  end
end
