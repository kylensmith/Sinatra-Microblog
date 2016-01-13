class CreateFollowTable < ActiveRecord::Migration
	def change
		create_table :follows do |t|
			t.integer :user_id
			t.integer :user_friend_id
		end
	end
end
