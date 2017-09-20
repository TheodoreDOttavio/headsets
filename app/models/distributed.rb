class Distributed < ActiveRecord::Base
  belongs_to :product #TODO - remove Products Table
  belongs_to :performance

  # Converting from Theaterstaff to Headsets.
  #  new Scopes starting with Selecting for Voice entry
  scope :findShift, ->(mymon, performanceid) {
    where(curtain: [mymon..(mymon + 6.days)], performance_id: performanceid)
  }

  # Scopes for xls and pdf reports

  scope :datespan, ->(mystart, myend) { where(curtain: [mystart..myend]) }

  scope :infrared, -> { where(product_id: [1, 3, 6, 7]) }
  scope :translation, -> { where(product_id: [4, 5], language: [2..20]) }
  scope :icapdesc, -> { where(product_id: [4, 5], language: [0..1]) }

  scope :onday, ->(myday) { where(curtain: [myday..(myday + 1)]) }
  scope :delivered, -> { where('quantity > 0') }

  # Scopes for Paperwork and Reports
  scope :allperformances, ->(mystart, myend) {
    where(curtain: [mystart..myend]).distinct.pluck(:performance_id)
  }
  scope :oneperformance, ->(mystart, myend, theater) {
    where(curtain: [mystart..myend], performance_id: theater.performance.id).distinct.pluck(:performance_id)
  }
  scope :infrared_for_oneperformance, ->(mystart, myend, performanceid) {
    where(curtain: [mystart..myend], performance_id: performanceid).infrared.order(:curtain, :eve)
  }
  scope :language_for_oneperformance, ->(mystart, myend, languageid, performanceid) {
    select(sum(:quantity))
      .where(curtain: [mystart..myend], performance_id: performanceid, language: languageid)
  }

  # Scopes for data entry
  scope :infraredwkcount, ->(mystart) { where(product_id: [1, 3, 6, 7]).datespan(mystart, (mystart + 6)).uniq.pluck(:performance_id).count }
  scope :scanscount, ->(mystart) { where(scan: true).datespan(mystart, (mystart + 6)).uniq.pluck(:performance_id).count }
  # scope :specialservicewkcount, ->(mystart) { where(product_id: [4,5], language: [2..20]).datespan(mystart, (mystart+7)).uniq.pluck(:performance_id).count }
  scope :shiftwkcount, ->(mystart) { where(product_id: [1, 6]).datespan(mystart, (mystart + 6)).count }
  scope :representativewkcount, ->(mystart) { where(product_id: [1, 6], representative: [2..1000]).datespan(mystart, (mystart + 6)).count }
  scope :representativetbdwkcount, ->(mystart) { where(product_id: [1, 6], representative: [nil, 0, 1]).datespan(mystart, (mystart + 6)).count }

  # Show a representative's work with links to scanned logs
  scope :schedule, ->(repid) { where(product_id: [1, 3, 6, 7], representative: repid).order(curtain: :desc) }

  scope :allmonths, -> {
    allmonths = []
    astart = DateTime.now.utc.beginning_of_day
    for i in 1..700 do
      mystart = astart - i
      next unless mystart.strftime('%d') == '01'
      if datespan(mystart, (mystart + 30)).infrared.exists?
        allmonths.push([mystart.strftime('%Y: %b'), mystart])
      end
    end
    return allmonths
  }

  scope :allweeks, ->(wkstart) {
    allweeks = []
    for i in 1..200 do
      mystart = wkstart - (i * 7)
      myend = mystart + 6
      # check to see if there's any data at all on that week
      if datespan(mystart, myend).infrared.exists?
        allweeks.push([mystart.strftime('%Y: %b %d') + ' to ' + myend.strftime('%b %d'), mystart])
      end
    end
    return allweeks
  }

  # for Blank Log Sheets
  scope :upcomingweeks, -> {
    allweeks = []
    weekstart = DateTime.now
    loop do
      break if weekstart.wday == 1
      weekstart -= 1.day
    end
    for i in 1..4 do
      mystart = weekstart + ((i - 1) * 7)
      myend = mystart + 6
      allweeks.push([mystart.strftime('%Y: %b %d') + ' to ' + myend.strftime('%b %d'), mystart])
    end
    return allweeks
  }

  # All Mondays in a year
  scope :monthsbymondays, ->(fullyearstring) {
    astart = DateTime.strptime(fullyearstring + '-12-31 24:00:00 UTC'[0..9], '%Y-%m-%d')
    mystart = astart
    allmondays = []
    # roll back four years and a lil extra - 50 mnonths
    for i in 1..50 do
      myend = mystart - 1.day # previous Sun
      mystart = astart + 1.day - i.month
      # push each iteration back to the past Monday
      loop do
        break if mystart.wday == 1
        mystart -= 1.day # set to Monday
      end
      # check that the week ends within the year
      allmondays.push([mystart, myend]) if myend.strftime('%Y') == fullyearstring
    end
    return allmondays.reverse # .sort_by{ |a| a[0] }
  }

  # Complete weeks goes back 3 years - used to place images (text vs. timestamp)
  scope :completeweeks, ->(wkstart) {
    completeweeks = []
    for i in 1..156 do
      mystart = wkstart - (i * 7)
      myend = mystart + 6
      completeweeks.push([mystart.strftime('%Y: %b %d') + ' to ' + myend.strftime('%b %d'), mystart.strftime('%Y-%m-%d')])
    end
    return completeweeks
  }
end
