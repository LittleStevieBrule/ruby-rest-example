
require 'sinatra/base'
require 'json'

# user account (0auth twitter)
#   posts (create delete modify)
#   add dogs(create delete modify)
#   able to post links to twitter about post
# anyone
#   can view blog posts
#
# Entities
#  Posts:
#     Attributes:
#         1. title
#         2. id
#         3. date created
#         4. date modified
#         4. dog tags:
#         5. content
#
#
# dogs:
#     Attributes:
#         1. name
#         2. id
#         3. breed (parsed and verified by dog api)
#         4. image (from dog api)
class Server < Sinatra::Base

  # some documentation html
  get '/' do

  end

  # * POSTS *

  # get all posts
  get '/posts' do

  end

  # get single post
  get '/posts/:id' do

  end

  # create a post (requires auth)
  post '/posts' do
    data = JSON.parse(request.body.read)
  end

  # modify a post  (requires auth)
  patch '/posts/:id' do

  end

  # deletes a post
  delete 'posts/:id' do

  end

  # tweet about your post
  post '/post/:id/tweet' do

  end

  # gets all posts for a breed
  get '/posts/:breed' do

  end

  #  * DOGS *

  # gets all dogs
  get '/dogs' do

  end

  # get a dog
  get '/dog/:id' do

  end

  # gets all dogs for a breed
  get '/dogs/:breed' do

  end

  # create a dog (requires auth)
  post '/dogs' do

  end

  # modify a dog (requires auth)
  patch 'dogs/:id' do

  end

  # delete a dog
  delete 'dogs/:id' do

  end

  # give a dog a bone (requires auth)
  post '/dogs/:id/bone' do

  end

  # * ME *

  # user info (requires auth)
  get '/me' do

  end

end