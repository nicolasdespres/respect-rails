class Contact < ActiveRecord::Base
  attr_accessible :age, :homepage, :name

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18 }
end
