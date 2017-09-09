class Product < ActiveRecord::Base
  has_many :performances, through: :cabinets
  has_many :cabinets, dependent: :destroy
  accepts_nested_attributes_for :cabinets,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :name, presence: true, length: { maximum: 50 }
end
