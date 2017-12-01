require 'rest-client'
# request helpers for making requests
module RequestHelpers

  def get(path)
    parse(RestClient.get(url(path)))
  end

  def post(path, data)
    transform_data!(data)
    parse(RestClient.post(url(path), data.to_json))
  end

  def delete(path)
    parse(RestClient.delete(url(path)))
  end

  def patch(path, data)
    transform_data!(data)
    parse(RestClient.patch(url(path), data.to_json))
  end

  def put(path, data = {})
    transform_data!(data)
    parse(RestClient.put(url(path), data.to_json))
  end

  def parse(response)
    data = JSON.parse(response.body)
    if data.is_a? ::Array
      data.map(&:convert_keys_to_sym)
    elsif data.is_a? ::Hash
      data.convert_keys_to_sym
    else
      data
    end
  end

  def url(path = '')
    "#{self::URL}:#{self::PORT}#{path}"
  end

  def transform_data!(data)
    data
  end

end