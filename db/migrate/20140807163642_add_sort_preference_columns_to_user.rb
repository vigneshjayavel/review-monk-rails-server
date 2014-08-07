class AddSortPreferenceColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :work_place, :string
  	add_column :users, :native_location, :string
  	add_column :users, :language, :string
  end
end
