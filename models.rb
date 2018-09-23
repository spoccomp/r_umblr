require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:rumblr-project'

class User < ActiveRecord::Base
  has_many :posts, :dependent => :delete_all
end

class Post < ActiveRecord::Base
  belongs_to :user
end



# CREATE TABLE posts (
#   id BIGSERIAL PRIMARY KEY,
#   title character varying,
#   content text,
#   created_at timestamp without time zone,
#   updated_at timestamp without time zone,
#   users_id bigint REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
# );