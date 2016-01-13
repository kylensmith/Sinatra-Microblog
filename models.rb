class User < ActiveRecord::Base
	has_one :profile  
	has_many :posts  
	has_many :follows
	has_many :user_friends, through: :follows
end

class Profile < ActiveRecord::Base
	belongs_to :user

end

class Post < ActiveRecord::Base
	belongs_to :user
end


class Follow < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_friend, class_name: "User"
end 

