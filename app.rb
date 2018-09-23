require 'sinatra'
require 'sendgrid-ruby'
require_relative 'models'


include SendGrid

set :sessions, true

def current_user
    if session[:user_id]
        return User.find(session[:user_id])
    end
end
def all_users
  @all = User.all
  return @all
end


get '/' do
    if session[:user_id]
      erb :user_profile, locals: { current_user: current_user }
    else
      erb :home
    end
end
get '/home' do
    erb :home
end
get '/login' do
    
    erb :login
end
post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect '/dashboard'
    else
      
      redirect '/create_account' 
    end
end
get '/create_account' do

    erb :create_account
    
end
post '/created' do
      # creates new user
      puts params[:username]
      user = User.create(
        username: params[:username],
        password: params[:password],
        code_lang: params[:code_language],
        first_name: params[:f_name],
        last_name: params[:l_name],
        birthday: params[:dob],
        email: params[:email] 
      )
      session[:message]= "Welcome to Code//Talk #{:username}!"
      # logs user in
      session[:user_id] = user.id
      # redirects to content page
      redirect '/dashboard'
end

 get '/dashboard' do
  @player = User.find(session[:user_id])
  @users = User.all
  # displays all post history
  @posts = Post.all
  # displays user post history
  users_id = session[:user_id]
  puts users_id
# use the where below to search for stuff in DB
# its like select * from posts where users_id = users_id
  @user_posts= Post.where("users_id = ?", session[:user_id])
  puts @user_posts
  puts "///////////////////////////////////////"
# display other user's posts

# the logic is on dashboard erb member's posts
# @user_array =[]
# @posts_array =[]
# @users.each do |user|
#   @user_array.push(user)
# end
# @posts.each do |post|
#   @posts_array.push(post)
# end
# puts @user_array.to_s
# puts @posts_array.to_s
# @my_posts = Post.where("users_id = ?", @users.id)
# puts @my_posts
# puts @value

# select "id","users_id","content" from posts where users_id = 2
# @my_posts = []
# result = ActiveRecord::Base.connection.exec_query('SELECT id, users_id, content FROM posts')
# result.each do |row|
#   @my_posts.push(row)
# end
# puts @my_posts.to_a


# test = Post.find_by_sql("SELECT id, users_id, content FROM posts
#   where users_id = '#{params[:user_select]}'")
# puts test
  erb :dashboard
 end
get '/my_posts' do
  erb :my_posts
end
post '/my_posts' do
  
  erb :my_posts
end
 post '/dashboard' do
  post = Post.create(
    title: params[:title],
    content: params[:content],
    users_id: current_user.id
  )

  redirect '/dashboard'
  
 end
  get '/cancel' do
    erb :cancel
  end

  post '/cancel' do
    puts "//////////////////////////////"
    # working on to delete user and their posts ***************
     userID = session[:user_id]
      puts userID 
    
    # p = Post.find_by users_id: userID 
    # puts posts
    # puts p
    # user = User.find(userID) && Post.find( posts.users_id)
    # user = User.find(userID)
#  HINT: Perhaps you meant to reference the column "posts.users_id". : SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = $1
    #  delete the user record and posts 
    # user.destroy
    # post.destroy
  #  @posts.each do |post|
  #   puts post.id
  #   puts post.title
  #   puts post.users_id
  #   x = post.users_id
  #   user = User.find(x)
  #   puts user.username
  #  end

   
    
    #   resets session to nil
    session[:user_id] = nil
    erb :cancel
  end

  get '/logout' do
    session[:user_id] = nil
    erb :home
  end



  # //////////////////////////////////
  # email
  get '/email' do
    # erb :email, locals, {email_from: email_from, email_send: email_send, email_subject: email_subject, email_text: email_text}
    erb :email
  end
  post "/email" do
   params.inspect
    from = Email.new(email: params[:email_from])
    to = Email.new(email: params[:email_send])
    # email: params[:email_address]
    subject = params[:email_subject]
    content = Content.new(
      type: 'text/html', 
      value: params[:email_text]
    )
    
    # create mail object with from, subject, to and content
    mail = Mail.new(from, subject, to, content)
    
    # sets up the api key
    sg = SendGrid::API.new(
      api_key: ENV["NAME"]
    )
    
    # sends the email
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    
    # display http response code
    puts response.status_code
    
    # display http response body
    puts response.body
    
    # display http response headers
    puts response.headers
  
     erb :home
    end