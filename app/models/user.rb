class User
  attr_reader :id

  def self.build_array(ids)
    ids.map { |id| new(id) }
  end

  def initialize(id)
    @id = Integer(id)
  end
end