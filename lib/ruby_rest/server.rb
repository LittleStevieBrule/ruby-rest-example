require_relative 'models/dog'
require_relative 'models/post'
require 'sinatra/base'
require 'octokit'
require_relative 'extensions/hash'
require_relative '../ruby_rest'


# user account (0auth twitter)
#   posts (create delete modify)
#   add dogs(create delete modify)
#   able to post links to twitter about post
# anyone
#   can view blog posts
def config
  RubyRest.config
end
class Server < Sinatra::Base


  ENTITIES = [Post, Dog].freeze
  VALID_RETURN_DATA ||= %i[success message] + ENTITIES.map do |e|
    e::VALID_RETURN_DATA
  end.flatten

  set :bind, config.bind
  set :port, config.port

  before do
    content_type :json
  end

  after do
    response.body = filter_res(response.body)
  end

  # some documentation html
  get '/' do
    status 200
    { message: 'test' }
  end

  # * POSTS *

  # get all posts
  get '/posts' do
    Post.all.map(&:attributes)
  end

  # get single post
  get '/posts/:id' do
    halt(404, message: 'Post Not Found') unless posting
    posting.attributes
  end

  # create a post (requires auth)
  post '/posts' do
    authenticate
    unless Post.required_keys?(data)
      halt(400, message: "#{Post::REQUIRED.join(',')} are required")
    end
    Post.create(data.merge(owner_name: name, owner_id: user_id)).attributes
  end

  # modify a post  (requires auth)
  patch '/posts/:id' do
    authenticate
    halt(404, message: 'Post Not Found') unless posting
    authorize posting
    posting.update_attributes!(data)
    posting.attributes
  end

  # deletes a post
  delete '/posts/:id' do
    authenticate
    halt(404, message: 'Post Not Found') unless posting
    authorize posting
    res = posting.delete
    { success: res }
  end

  #  * DOGS *

  # gets all dogs
  get '/dogs' do
    Dog.all.map(&:attributes)
  end

  # get a dog
  get '/dogs/:id' do
    halt(404, message: 'Dog Not Found') unless dog
    dog.attributes
  end

  # gets all dogs for a breed
  get '/dogs/breed/:breed' do |breed|
    Dog.where(breed: breed.gsub('_', ' ')).map(&:attributes)
  end

  # create a dog (requires auth)
  post '/dogs' do
    authenticate
    unless Dog.required_keys?(data)
      halt(400, message: "#{Dog::REQUIRED.join(',')} are required")
    end
    Dog.create(data.merge(owner_name: name, owner_id: user_id)).attributes
  end

  # modify a dog (requires auth)
  patch '/dogs/:id' do |id|
    authenticate
    halt(404, message: 'Post Not Found') unless dog
    authorize dog
    dog.update_attributes!(data)
    Dog.where(dog_id: id).first.attributes
  end

  # delete a dog
  delete '/dogs/:id' do |id|
    authenticate
    halt(404, message: 'Dog Not Found') unless dog
    authorize dog
    Post.delete_dogs_id(id)
    res = dog.delete
    status 200
    { success: res }
  end

  # give a dog a bone (requires auth)
  put '/dogs/:id/bone' do
    authenticate
    halt(404, message: 'Dog Not Found') unless dog
    dog.give_a_bone
    status 200
    body(message: 'success')
  end

  def client
    @client ||=
      begin
        access_token = params['access_token'] ? params['access_token'] : data[:access_token]
        Octokit::Client.new(access_token: access_token)
      end
  end

  def authenticate
    client.user.login
  rescue Octokit::Unauthorized => e
    status = e.response_status
    message = e.message[%r{: \d{3} - (.*?) //}, 1]
    halt status, message: message
  end

  def name
    client.user[:name]
  end

  def user_id
    client.user[:id]
  end

  def authorize(entity)
    halt 401 unless entity[:owner_id] == user_id
  end

  def posting
    Post.where(post_id: params['id']).first
  end

  def dog
    @dog ||= Dog.where(dog_id: params['id']).first
  end

  def data
    @data ||= begin
      bod = request.body.read
      if bod.empty?
        params
      else
        JSON.parse(bod)
      end.convert_keys_to_sym
    end
  end

  def filter_res(data)
    convert = proc do |hash|
      hash.convert_keys_to_sym.select do |k, _|
        VALID_RETURN_DATA.include?(k)
      end
    end
    if data.is_a? ::Array
      data.map { |e| convert.call(e) }
    elsif data.is_a? ::Hash
      convert.call(data)
    else
      data
    end.to_json
  end

end
