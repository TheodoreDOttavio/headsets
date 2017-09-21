# Rake db:addscans

namespace :db do
  desc 'Add scanned logs to db'
  task addscans: :environment do
    require 'fileutils'

    puts 'Cleaning out the Scans db table'
    ActiveRecord::Base.transaction do
      Scan.destroy_all
    end

    puts 'Adding Files'

    yearlist = Dir.glob('app/assets/images/2*')
    yearlist.each do |y|
      puts 'adding year ' + y.split('/').last
      idlist = Dir.glob(y.to_s + '/*')
      idlist.each do |i|
        scanlist = Dir.glob(i.to_s + '/*.jpg')
        scanlist.each do |scan|
          filename = scan.split('/').last
          mondayarray = filename.split('-')
          id = filename.split('-').first
          ss = if filename.split('-').last.split('.').first == '2'
                 true
               else
                 false
               end
          monday = DateTime.new(mondayarray[1].to_i, mondayarray[2].to_i, mondayarray[3].to_i)

          processed = false
          if ss then
            check = Distributed.findShift(monday, id).translation
            processed = true if check.count != 0
          else
            check = Distributed.findShift(monday, id).infrared
            processed = true if check.count != 0
          end

          ActiveRecord::Base.transaction do
            obj = Scan.new(performance_id: id, monday: monday, specialservices: ss, isprocessed: processed)
            obj.save
          end
        end
      end
    end

    puts "all jpg files scanned added, and marked as processed if data was found. This reset Scan.id's and relies on the Scans.rb controller to record files..."
  end # task

  task runme: :environment do
    # kwik fix thingy...  puts Distributed.onday(weekstart-730).inspect
    weekstart = DateTime.now.utc.beginning_of_day - 691
    loop do
      break if weekstart.wday == 1
      weekstart -= 1.day
    end

    puts weekstart
    obj = Distributed.datespan(weekstart, weekstart + 6)
    count = 0

    obj.each do
      puts Performance.find(obj[count].performance_id).name
      puts obj[count].curtain.strftime('%A - %b %d')
      Distributed.find(obj[count].id).destroy
      count += 1
      puts '----'
    end
  end


  # task populate_isprocessed: :environment do
  #   #mark infrared sheets
  #   # allobjs = Scan.where(isprocessed: true)
  #   # puts "Resetting " + allobjs.count.to_s + " to unprocessed"
  #   # allobjs.each do |obj|
  #   #   obj.isprocessed = true
  #   #   obj.save
  #   # end
  #
  #   allobjs = Scan.where(isprocessed: false, specialservices: true)#.limit(100)
  #   allobjs.each do |obj|
  #     show = Performance.find(obj.performance_id)
  #     if show.nil? == false then
  #       check = Distributed.findShift(obj.monday, obj.performance_id).translation
  #       if check.count != 0 then
  #         obj.isprocessed = true
  #         puts " setting processed to true " + check.count.to_s + " translation shifts for " + show.name.to_s + " on - " + obj.monday.strftime('%b %d, %Y')
  #         # obj.save
  #       end
  #     end
  #   end
  # end


  task transposeproduct: :environment do
    puts "Converting product ID's in Distributeds datum to unify headsets and loops"
    @change = Distributed.where(product_id: 1).update_all(product_id: 6)
    @change = Distributed.where(product_id: 3).update_all(product_id: 7)
    @change = Cabinet.where(product_id: 1).update_all(product_id: 6)
    # leave a hint. no change to batteries @change = Cabinet.where(product_id: 2).update_all(product_id: 8)
    @change = Cabinet.where(product_id: 3).update_all(product_id: 7)
    #TODO move all icap to r4 by looking at language_id
  end
end
