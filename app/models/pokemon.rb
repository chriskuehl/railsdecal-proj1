class Pokemon < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :trainer

  def add_exp(exp)
    self.experience += exp

    if exp >= exp_needed() # level up!
      self.experience = 0
      self.level += 1
    end
  end

  def exp_needed
    return self.level ** 2
  end
end
