class CreateFollowersTable < ActiveRecord::Migration
	def change
		create_table :followers do |t|
			t.integer :main_user
			t.integer :to_follow
		end
	end
end
