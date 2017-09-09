class Available < ActiveRecord::Base
  belongs_to :user

  scope :onday, ->(myday) { where(day: [myday..(myday + 1)]) }
  # scope :inday, ->(myday) { where(day: [(myday - 1.hour)..(myday + 1.hour)]) }
  scope :datespan, ->(mystart, myend) { where(day: [mystart..myend]) }

  validates :day, presence: true
  validates :user_id, presence: true
end
