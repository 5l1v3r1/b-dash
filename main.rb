require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'sinatra/activerecord'
require 'open-uri'
require 'nokogiri'

ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'
if settings.production?
  set :database, ENV['DATABASE_URL'] || 'postgres://localhost/b-dash'
else
  set :database, "sqlite3:db/development.sqlite3"
  # ActiveRecord::Base.establish_connection(
  #   :adapter => 'sqlite3',
  #   :dbfile =>  'db/development.db'
  # )
end

if settings.production?
  use Rack::Auth::Basic do |username, password|
    username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
  end
end

class User < ActiveRecord::Base
end

class Bookmark < ActiveRecord::Base
  belongs_to :user
end

after do
  ActiveRecord::Base.connection.close
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  redirect '/bookmarks'
end

# Users

get '/users' do
  @users = User.order("id desc").all
  erb :'users/index'
end

get '/users/new' do
  erb :'users/new'
end

post '/users/create' do
  User.create(username: params[:username], email: params[:email])
  redirect '/users'
end

post '/users/delete' do
  User.find(params[:id]).destroy
end

# Bookmarks

get '/bookmarks' do
  @bookmarks = Bookmark.order("id desc").all
  erb :'bookmarks/index'
end

get '/bookmarks/new' do
  erb :'bookmarks/new'
end

post '/bookmarks/create' do
  user = User.where(username: params[:username]).first
  title = Nokogiri::HTML(open(params[:url])).at_css("title").text
  Bookmark.create(url: params[:url], title: title, user_id: user && user.id, created_at: Time.now)
  redirect '/bookmarks'
end

post '/bookmarks/delete' do
  Bookmark.find(params[:id]).destroy
end
