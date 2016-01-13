class CreatePostsTable < ActiveRecord::Migration
	def change
		create_table :posts do |t|
			t.string :content
			t.datetime :posted_at
			t.datetime :created_at
			t.integer :user_id
		end
	end
end
