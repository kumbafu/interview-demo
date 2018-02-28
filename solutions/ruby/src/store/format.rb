class Format
  VALID_FORMATS = ['cd','tape','vinyl']
  attr_accessor :name,:uuid,:count
  def initialize(args)
    self.count = args[:count].to_i
    self.name = args[:name].downcase
    self.uuid = args[:uuid] || SecureRandom.uuid
  end

  def to_hash
    {name: name,
     uuid: uuid,
     count: count
    }
  end
end

