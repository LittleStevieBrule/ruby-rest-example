module Helpers

  def filter_data(data)
    data.convert_keys_to_sym.select do |k, _|
      self::VALID_DATA.keys.include? k.to_sym
    end
  end

  def required_keys?(data)
    data.convert_keys_to_sym.keys.select do |key|
      self::REQUIRED.include? key
    end == self::REQUIRED
  end

end