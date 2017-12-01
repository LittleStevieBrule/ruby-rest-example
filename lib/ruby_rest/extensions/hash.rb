
class Hash
  def convert_keys_to_sym
    keys.map(&:to_sym).zip(values).to_h
  end
end