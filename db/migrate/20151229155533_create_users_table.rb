class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string   :email
			t.string   :name
			t.string   :city
			t.string   :password
			t.datetime :created_at
		end
	end
end
