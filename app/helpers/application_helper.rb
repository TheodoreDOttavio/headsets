module ApplicationHelper
  def full_title(page_title)
    base_title = 'Theater Staff Schedule'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def findlog(astart, performanceid, format)
    loop do
      break if astart.wday == 1
      astart -= 1.day
    end
    logfile = astart.strftime('%Y') + '/' +
              performanceid.to_s + '/' +
              performanceid.to_s + '-' +
              astart.strftime('%Y-%m-%d') + '-' + format.to_s + '.jpg'
    puts "-------------findlog called :" + 'app/assets/images/' + logfile
    return logfile if File.exist?('app/assets/images/' + logfile)
  end

end


def archivedate(databasedate)
  mydatearray = databasedate.to_s[0..9].split('-').map(&:to_i)

  if mydatearray.length == 3
    mydate = DateTime.new(mydatearray[0], mydatearray[1], mydatearray[2])
  else
    mydate = DateTime.strptime('2014-10-04 20:00:00 UTC'[0..9], '%Y-%m-%d')
  end

  showdate = mydate.strftime('%b %d, \'%y')
  showdate
end
