class AlterGpsUsers < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		ALTER TABLE `users`
  		CHANGE `gps_latitude` `gps_latitude` decimal(40,30) DEFAULT NULL, 
  		CHANGE `gps_longitude` `gps_longitude` decimal(40,30) DEFAULT NULL
  	SQL
  end

  def down
  end
end
