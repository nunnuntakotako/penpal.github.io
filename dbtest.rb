require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'

set :environment, :production

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Memberdata < ActiveRecord::Base
  self.table_name = 'memberdata'
end

get '/' do
  t = Memberdata.all

  @h = ""
  t.each do |a|
    @h = @h + "<tr>"
    @h = @h + "<td><a href='/mypage/#{a.id}'>#{a.id}</a></td>"
    @h = @h + "<td>#{a.first_name}</td>"
    @h = @h + "<td>#{a.last_name}</td>"
    @h = @h + "<td>#{a.birth_year}</td>"
    @h = @h + "<td>#{a.birth_month}</td>"
    @h = @h + "<td>#{a.birth_day}</td>"

    @h = @h + "</tr>\n"

  end

  erb :index
end

get '/register' do
  erb :register
end

post '/register' do
  s = Memberdata.new
  s.id = params[:id]
  s.first_name = params[:first_name]
  s.last_name = params[:last_name]
  s.birth_year = params[:birth_year]
  s.birth_month = params[:birth_month]
  s.birth_day = params[:birth_day]
  s.save
  redirect '/'
end

delete '/del' do
  s = Memberdata.find(params[:id])
  s.destroy
  redirect '/'
end

get '/mypage/:id' do
  @s = Memberdata.find_by_id(params[:id])
  erb :mypage
end
