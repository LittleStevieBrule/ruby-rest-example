# RubyRest

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ruby_rest`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Requirements

Ruby 2.4.0 or higher. You can try lower versions but I do not recommend it. I suggest using [RVM](https://rvm.io/rvm/install) if you don't have ruby
installed already

Make sure you can run:

        ruby -v

## Running the tests

These are the following steps for running the tests against the live server running on http://35.196.169.169/8080

From the root directory of this project run the following commands

Install bundler ruby gem
        
        gem install bundler
        
Install the gem dependencies

        bundle install
        
Execute the tests

        bundle exec rake


## API

### Authentication
    All requests marked with (requires auth) must provide
### Entities
Entities
    Post:
        
        title: String
        post_id: Integer
        date_created: String
        content: String
        dogs_ids: Array
        owner_name: String
        owner_id: Integer
  
   
   Dog:
       
        name: String
        dog_id: Integer
        breed: String
        breed_images: Array
        bones: Integer
        owner_name: String
        owner_id: Integer
        
### Routes

#### `GET /posts`

Get all posts 


#### `GET /posts/{post_id}` 

get single post
          
#### `POST /posts`

Create a post

Request JSON: 

   ```json
       { 
         "title": "My awesome dog Slippy!",
         "content": "This is where I talk about how awesome my dog slippy is", 
         "dog_ids": [1234,4321],
         "access_token": "<my Github access token>"
       }
   ```
   
Response:

``` json
200 
    { 
     "title": "My awesome dog Slippy!",
     "content": "This is where I talk about how awesome my dog slippy is", 
     "dog_ids": [1234,4321]
    }
    
```

You need to be 



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

POST /dogs         

create a dog (requires auth


          
Response:
```json
{
   "name":"Slippers",
   "breed":"american cocker spaniel",
   "owner_name":"Stephen D. McGuckin",
   "dog_id":1512115574454,
   "bones":0,
   "breed_images":
        ["https://dog.ceo/api/img/spaniel-cocker/n02102318_9307.jpg",
        "https://dog.ceo/api/img/spaniel-brittany/n02101388_4342.jpg"]
}
```
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


#### user accounts (0auth twitter)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_rest.
