class Cabinet < ActiveRecord::Base
  belongs_to :product
  belongs_to :performance

  scope :translation, -> { select(:performance_id).where(product_id: [4, 5]).distinct.pluck(:performance_id) }
end
