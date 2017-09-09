# Rake db:migrate_20160324

namespace :db do
  desc 'Sets booleans for Infrared Product and scanned sheets'
  # http://www.stackoverflow.com/questions/876396/do-rails-rake-tasks-provide-access-to-activerecord-models

  task migrate_20160324: :environment do
    puts 'Setting all isinfrared booleans to false'
    Distributed.update_all(isinfrared: false)
    puts 'selecting all distributeds by product id'
    # NOT using the .infrared scope because that needs to be depreciated after this migration
    obj = Distributed.where(product_id: [1, 3, 6, 7])
    obj.update_all(isinfrared: true)
    puts obj.count
    puts 'Completed'

    puts'Review each performance, one week at a time, and set scans boolean to each shift record of Distributeds'
    # Clean Slate
    puts 'Setting all scan booleans to false'
    Distributed.update_all(scan: false)

    # find start and end dates
    obj = Distributed.order(:curtain).limit(1)
    datestart = obj[0].curtain

    weekstart = datestart
    loop do
      break if weekstart.wday == 1
      weekstart -= 1.day
    end

    obj = Distributed.order(curtain: :desc).limit(1)
    dateend = obj[0].curtain

    # pull a list of all performance ID's
    performanceidlist = Performance.selectionlist

    while weekstart < dateend
      performanceidlist.each do |name, id|
        # Infrared Daily logs
        rows = Distributed.datespan(weekstart, weekstart + 6.day).where(performance_id: id, isinfrared: true)
        unless rows.empty?
          logfile = weekstart.strftime('%Y') + '/' +
                    id.to_s + '/' +
                    id.to_s + '-' +
                    weekstart.strftime('%Y-%m-%d') + '-1.jpg'
          if File.exist?('app/assets/images/' + logfile)
            puts 'adding Log for ' + name.to_s + ' in the week of ' + weekstart.strftime('%Y-%m-%d')
            rows.update_all(scan: true)
          end
        end

        # ...aaaand Special Services logs Note, this is a lot of file checking for very few (if optimising is needed)
        ssrows = Distributed.datespan(weekstart, weekstart + 6.day).where(performance_id: id, isinfrared: false)
        next if ssrows.empty?
        logfile = weekstart.strftime('%Y') + '/' +
                  id.to_s + '/' +
                  id.to_s + '-' +
                  weekstart.strftime('%Y-%m-%d') + '-2.jpg'
        if File.exist?('app/assets/images/' + logfile)
          puts 'adding ss Log for ' + name.to_s + ' in the week of ' + weekstart.strftime('%Y-%m-%d')
          ssrows.update_all(scan: true)
        end
      end
      weekstart += 7.day
    end

    puts 'all set, the logs present in app/assets/images/ are updated in the Distributeds datum'
  end # task
end
