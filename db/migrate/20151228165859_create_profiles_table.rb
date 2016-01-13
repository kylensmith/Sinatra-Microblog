class CreateProfilesTable < ActiveRecord::Migration
	def change
		create_table :profiles do |t|
			t.integer :user_id
			t.string :name
			t.string :bio
			t.string :city
			t.string :picture
			t.string :bg_color
			t.string :text_color
		end
	end
end
