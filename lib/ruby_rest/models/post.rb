require 'mongoid'
require_relative 'helpers'
#  Posts:
#     Attributes:
#         1. title
#         2. id
#         3. date created
#         4. dog images:
#         5. content

class Post
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  extend Helpers

  VALID_DATA = {
    title: String,
    post_id: Integer,
    date_created: String,
    content: String,
    dogs_ids: Array,
    owner_name: String,
    owner_id: Integer
  }.freeze
  REQUIRED = %i[title content].freeze
  MUTABLE_KEYS =
    %i[title content date_created dog_ids owner_name].freeze
  VALID_RETURN_DATA = %i[title post_id date_created dog_ids content owner_name].freeze

  VALID_DATA.each do |k, v|
    field k, type: v
  end

  def self.create_resource(attributes, &block)
    attributes = filter_data attributes
    time = Time.now
    attributes[:dog_ids] = [] unless attributes[:dog_ids]
    attributes[:post_id] = DateTime.now.strftime('%Q')
    attributes[:date_created] = "#{time.month}/#{time.day}/#{time.year}"
    create(attributes, &block)
  end

  def self.put_resource(attributes, id)
    attributes = filter_data attributes
    attributes[:dog_ids] = [] unless attributes[:dog_ids]
    attributes[:post_id] = id
    time = Time.now
    attributes[:date_created] = "#{time.month}/#{time.day}/#{time.year}"
    create(attributes)
  end

  def update_attributes!(attributes)
    attributes = attributes.convert_keys_to_sym
    super(
      attributes.select do |key, _|
        MUTABLE_KEYS.include?(key)
      end
    )
  end

  def self.delete_dogs_id(id)
    where(dog_ids: id.to_i).all.each do |post|
      dog_ids = post[:dog_ids].dup
      dog_ids.delete(id.to_i)
      dog_ids = [] if dog_ids.nil?
      post.update_attributes!(dog_ids: dog_ids)
    end
  end

end
