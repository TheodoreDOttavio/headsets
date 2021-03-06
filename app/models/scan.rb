class Scan < ActiveRecord::Base
  belongs_to :performance

  # Scopes for Paperwork and Reports
  scope :scanscount, ->(mystart) { where(monday: mystart, specialservices: true).uniq.pluck(:performance_id).count }
  scope :ssscanscount, ->(mystart) { where(monday: mystart, specialservices: false).uniq.pluck(:performance_id).count }

  scope :unprocessed, ->() { where(isprocessed: false).order(monday: :asc).limit(1) } #order(id: :desc)
  # scope :unprocessed, ->() { where(isprocessed: false).where(monday: (Time.now.midnight - 180.day)..Time.now.midnight).order(monday: :asc).limit(1) } #order(id: :desc)
  # scope :unprocessedCount, ->() { select(:id).where(isprocessed: false).where(monday: (Time.now.midnight - 180.day)..Time.now.midnight) }
  scope :unprocessedCount, ->() { select(:id).where(isprocessed: false) }
  # scope :anydate, ->(myday) { where(monday: weekstart(myday)) }

  validates :performance_id, presence: true
  validates :monday, presence: true
end
