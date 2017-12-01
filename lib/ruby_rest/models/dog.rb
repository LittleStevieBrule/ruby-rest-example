require 'mongoid'
require_relative 'helpers'
require_relative '../dog_client'
# dog model
class Dog
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  extend Helpers

  VALID_DATA = {
    name: String,
    dog_id: Integer,
    breed: String,
    breed_images: Array,
    bones: Integer,
    owner_name: String,
    owner_id: Integer
  }.freeze
  REQUIRED = %i[name breed].freeze
  VALID_RETURN_DATA = %i[name dog_id breed breed_images bones owner_name].freeze

  VALID_DATA.each do |k, v|
    field k, type: v
  end

  def self.create(attributes = nil, &block)
    attributes = filter_data attributes
    attributes[:dog_id] = DateTime.now.strftime('%Q')
    attributes[:bones] = 0
    attributes[:breed_images] = DogClient.get_images(attributes[:breed])
    super(attributes, &block)
  end

  def give_a_bone
    update(bones: bones + 1)
  end

  def update_attributes!(attributes)
    attributes = attributes.convert_keys_to_sym
    super(
      attributes.select do |key, _|
        %i[name breed].include?(key)
      end
    )
  end

end
