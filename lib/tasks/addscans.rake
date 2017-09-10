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
      puts 'adding year' + y.split('/').last
      idlist = Dir.glob(y.to_s + '/*')
      idlist.each do |i|
        scanlist = Dir.glob(i.to_s + '/*.jpg')
        scanlist.each do |scan|
          filename = scan.split('/').last
          mondayarray = filename.split('-')
          id = filename.split('-').first
          ss = if filename.split('-').last.split('.').first == '1'
                 true
               else
                 false
               end
          monday = DateTime.new(mondayarray[1].to_i, mondayarray[2].to_i, mondayarray[3].to_i)

          ActiveRecord::Base.transaction do
            obj = Scan.new(performance_id: id, monday: monday, specialservices: ss)
            obj.save
          end
        end
      end
    end

    puts "all jpg files scanned added. This reset Scan.id's and relies on the Scans.rb controller to record files..."
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


  task transposeproduct: :environment do
    puts "Converting product ID's in Distributeds datum to a product category ID"
    # Convert produt ID's to Product type
    # 10 Infrared
    # 20 Loop
    # 30 Descriptive
    # 40 iCaption
    # 50 Translation
    # NOTE use  = Shortlists.new.productCategories for name....
    #scope :infrared, -> { where(product_id: [1, 3, 6, 7]) }
    #scope :translation, -> { where(product_id: [4, 5], language: [2..20]) }
    #scope :icapdesc, -> { where(product_id: [4, 5], language: [0..1]) }

    transposeHash = {1 => 10, 3 => 20, 6 => 10, 7 => 20}
    # 4 => 50, 5 => 40 Need to make use of the language field in each Distributeds record.

    #NOTE split translation by language into descriptive and translation
  end
end
