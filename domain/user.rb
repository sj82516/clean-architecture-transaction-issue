class User
  def initialize(id, points)
    self.id = id
    self.points = points
  end

  attr_accessor :id, :points

  def can_purchase?(cost)
    points >= cost
  end
end
