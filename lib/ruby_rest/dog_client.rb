require_relative 'request_helpers'
# dog api client
class DogClient
  URL = 'https://dog.ceo'.freeze
  PORT = ''.freeze
  extend RequestHelpers

  def self.breed_list
    get('/api/breeds/list')[:message]
  end

  def self.sub_breed(breed_name)
    get("/api/breed/#{breed_name}/list")[:message]
  end

  def self.get_img_breed(breed)
    get("/api/breed/#{breed}/images/random")[:message]
  end

  def self.get_img_sub_breed(breed, sub_breed)
    get("/api/breed/#{breed}/#{sub_breed}/images/random")[:message]
  end

  def self.get_images(string)
    imgs = []
    breeds = breed_list
    arr = string.downcase.gsub(/[^a-z ]/i, ' ').split(' ')
    arr.select { |str| breeds.include?(str) }.each do |breed|
      sub_breed = sub_breed(breed)
      arr.select { |sub| sub_breed.include? sub }.each do |sub|
        imgs << get_img_sub_breed(breed, sub)
      end
      imgs << get_img_breed(breed)
    end
    imgs
  end

end