class PapersController < ApplicationController
  def index
    if current_user.admin?
      # Theater listing with extra selections
      @theaters = []
      @theaters.push(['All Theaters', 1])

      companies = Shortlists.new.companies
      companies.each_with_index do |company, _companyindex|
        @theaters.push(['All ' + company[0] + ' Theaters', company[1]])
      end

      theaters = Theater.select(:id, :name)
      theaters.each do |t|
        @theaters.push([t.name, t.id]) if t.id != 1
      end

      # Delivery Options
      @deliveryformat = []
      @deliveryformat.push(['Download', 1])
      @deliveryformat.push(['Email: ', 2])

      # for weekly output function
      @outputformat = []
      @outputformat.push(['PDF Cover Sheet', 1])
      @outputformat.push(['MS Excell Files', 2])

      # for Blank Paperwork
      @upcomingweeks = Distributed.upcomingweeks

      # for monthly reports
      @allmonths = Distributed.allmonths

      # for weekly xls reports, PDF cover sheets, and paper log view
      @allweeks = Distributed.allweeks(weekstart)

      # for Viewing timespan of Paper Logs Scanned in
      @performances = Performance.selectionlist

      @ssperformances = Performance.ssselectionlist # Cabinet.translation

      @showyears = []
      for x in 0..3 do
        showyear = DateTime.now.strftime('%Y').to_i - x
        @showyears.push([showyear.to_s, showyear.to_s])
      end

    #     #Display where the data is at - overview of what has been entered
    #     @weektoedit = Array.new
    #     @weekstartstoedit = []
    #     for i in 1..104 do
    #       mystart = weekstart - (i * 7)
    #
    #       #add in some info about what has been entered
    #       myshowcount = Performance.showingcount(mystart, (mystart+7))
    #       myinfraredcount = Distributed.infraredwkcount(mystart)
    #       myspecialservicescount = Distributed.specialservicewkcount(mystart)
    #       myshiftcount = Distributed.shiftwkcount(mystart)
    #       myrepcount = Distributed.representativewkcount(mystart)
    #       mytbdrepcount = Distributed.representativetbdwkcount(mystart)
    #
    #       if myinfraredcount == 0 && myspecialservicescount == 0 then
    #         mybuttonclass = "btn btn-sm btn-danger"
    #       else
    #         if myinfraredcount < myshowcount then
    #           myclass = "warningbold"
    #         else
    #           myclass = "editbold"
    #         end
    #       end
    #
    #       @weektoedit.push({"showweekof" => mystart.strftime('%b %d')+" to "+ (mystart+7).strftime('%b %d, %Y'),
    #         "startdate" => mystart,
    #         "showcount" => myshowcount,
    #         "infraredcount" => myinfraredcount,
    #         "specialservicescount" => myspecialservicescount,
    #         "shiftcount" => myshiftcount,
    #         "repcount" => myrepcount,
    #         "tbdcount" => mytbdrepcount,
    #         "myclass" => mybuttonclass})
    #     end
    else
      redirect_to root_url
    end
  end

  def generateweekly
    case params[:xportas]
    when '1'
      generateweeklypdf
    when '2'
      generateweeklyxls
    else
      flash[:error] = 'Select A PDF cover sheet or a zip file of MS Excel documents for each theater'
    end
    # redirect_to papers_path
  end

  def generatemonthly
    require 'fileutils'
    require 'rubygems'
    require 'zip'

    # clean up... remove existing files
    FileUtils.rm Dir.glob('app/reports/monthbytheater/*.xls')
    FileUtils.rm Dir.glob('app/reports/month-by-theater_*.zip')

    mystart = params[:xportmonthstart].to_date

    Xlsgenerator.new.generatemonthly(mystart, params[:xporttheater])

    excelfilelist = Dir.glob('app/reports/monthbytheater/*' + mystart.strftime('%b_%Y') + '.xls')

    if excelfilelist.empty?
      flash[:error] = 'No Data Found'
      redirect_to papers_path
    else
      # generate a zipfile and send it as a link
      zipfile_name = ('app/reports/month-by-theater_' + mystart.strftime('%b_%Y') + '.zip')
      folder = 'app/reports/monthbytheater'

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        excelfilelist.each do |filename|
          zipfile.add(filename.split('/')[3], filename)
        end
      end

      send_file zipfile_name, filename: zipfile_name.split('/')[3],
                              type: 'application/zip',
                              disposition: 'attachment'
   end
  end

  def generatemonthlyss
    Xlsgenerator.new.generatemonthlyss(params[:xportperformance], params[:xportyear])

    folder = 'app/reports/monthbytheater/'
    thisperformance = Performance.find(params[:xportperformance])
    file = thisperformance.name + '-special-services.xls'

    send_file folder + file, filename: file,
                             type: 'application/xls',
                             disposition: 'attachment'
  end

  def generateweeklyxls
    require 'fileutils'
    require 'rubygems'
    require 'zip'

    mystart = params[:xportweekstart].to_date

    Xlsgenerator.new.generateweeklyxls(mystart)

    excelfilelist = Dir.glob('app/reports/weekbytheater/*' + mystart.strftime('%Y_%m_%d') + '.xls')

    if excelfilelist.empty?
      flash[:error] = 'No Data Found for the week of ' + @weekof
      redirect_to papers_path
    else
      # generate a zipfile and send it as a link
      zipfile_name = ('app/reports/week-by-theater_' + mystart.strftime('%Y_%m_%d') + '.zip')
      folder = 'app/reports/weekbytheater'

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        excelfilelist.each do |filename|
          zipfile.add(filename.split('/')[3], filename)
        end
      end

      send_file zipfile_name, filename: zipfile_name.split('/')[3],
                              type: 'application/zip',
                              disposition: 'attachment'
    end
  end

  def generateweeklypdf
    # Build a PDF....

    mystart = params[:xportweekstart].to_date
    myend = mystart + 7

    # Make a list of performances
    myshows = Distributed.datespan(mystart, myend).joins(:performance).order('name').select('name', :performance_id).distinct
    totaldistributed = Array.new(11, 0)

    report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'showweek.tlf')
    report.start_new_page

    report.page.item(:weekof).value(mystart.strftime('%b %d, %Y'))

    myshows.each do |show|
      producttotals = []

      report.list.add_row do |row|
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [1, 6], 0))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [3, 7], 0))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, 5, 1))
        # [3] descriptive on r4 and comtek
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 2))
        # [4] chinese - languages are listed (commented out in seeds.db)
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 3))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 4))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 5))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 6))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 7))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 8))
        producttotals.push(weeklyproductcounter(mystart, myend, show.performance.id, [4, 5], 9))

        # add this up for totals in the footer
        totaldistributed.count.times do |t|
          unless producttotals[t].nil?
            totaldistributed[t] = producttotals[t].to_i + totaldistributed[t]
          end
        end

        # write the values to the pdf
        row.values theater: show.performance.theater.name,
                   performance: show.performance.name,
                   headsets: producttotals[0],
                   loops: producttotals[1],
                   icap: producttotals[2],
                   desc: producttotals[3],
                   chi: producttotals[4],
                   fre: producttotals[5],
                   ger: producttotals[6],
                   jpn: producttotals[7],
                   ptg: producttotals[8],
                   spn: producttotals[9],
                   tur: producttotals[10]
      end
    end

    # and write the totals
    report.page.item(:totheadsets).value(totaldistributed[0])
    report.page.item(:totloops).value(totaldistributed[1])
    report.page.item(:toticap).value(totaldistributed[2])
    report.page.item(:totdesc).value(totaldistributed[3])
    report.page.item(:totchi).value(totaldistributed[4])
    report.page.item(:totfre).value(totaldistributed[5])
    report.page.item(:totger).value(totaldistributed[6])
    report.page.item(:totjpn).value(totaldistributed[7])
    report.page.item(:totptg).value(totaldistributed[8])
    report.page.item(:totspn).value(totaldistributed[9])
    report.page.item(:tottur).value(totaldistributed[10])

    send_data report.generate, filename: 'datacoversheet_' + mystart.strftime('%Y_%m_%d') + '.pdf',
                               type: 'application/pdf',
                               disposition: 'attachment'
    end

  def logview
    @allweeks = Distributed.allweeks(weekstart)
    @performances = Performance.selectionlist
    @viewlist = []

    case params[:logset].to_i
    when 1
      performanceidlist = Distributed.allperformances(params[:xportweekstart].to_date, params[:xportweekstart].to_date + 7)

      performanceidlist.each do |p|
        logimage = findlog(params[:xportweekstart].to_date, p, 1)
        sslogimage = findlog(params[:xportweekstart].to_date, p, 2)
        @viewlist.push(logimage) unless logimage.nil?
        @viewlist.push(sslogimage) unless sslogimage.nil?
      end
    when 2
      mystart = weekstart # findlog corrects this to Mondays
      for i in 1..156 do
        ws = mystart - (i * 7)
        logimage = findlog(ws, params[:xportperformance], 1)
        sslogimage = findlog(ws, params[:xportperformance], 2)
        @viewlist.push(logimage) unless logimage.nil?
        @viewlist.push(sslogimage) unless sslogimage.nil?
      end
    end
  end

  def weeklyproductcounter(mystart, myend, myperformance_id, myproduct_id, mylanguage_id)
    headsets = Distributed.datespan(mystart, myend).select(:quantity).where(product_id: myproduct_id, language: mylanguage_id, performance_id: myperformance_id)
    thisvalue = 0
    headsets.each do |d|
      thisvalue += d.quantity
    end
    if thisvalue == 0
      return '.'
    else
      return thisvalue
    end
    end

  def printlogs
    mystart = params[:xportweekstart].to_date
    myend = params[:xportweekstart].to_date + 6.day

    performancelist = Performance.showinglogs(mystart)
    report = ThinReports::Report.new

    performancelist.each do |p|
      report.start_new_page layout: File.join(Rails.root, 'app', 'reports', 'infraredlog.tlf')
      report.page.item(:weekof).value(mystart.strftime('%b %d') + ' to ' + myend.strftime('%b %d, %Y'))
      report.page.item(:theater).value(p.theater_name)
      report.page.item(:performance).value(p.name)

      next unless p.specialservices == true
      report.start_new_page layout: File.join(Rails.root, 'app', 'reports', 'specialserviceslog.tlf')
      report.page.item(:weekof).value(mystart.strftime('%b %d') + ' to ' + myend.strftime('%b %d, %Y'))
      report.page.item(:theater).value(p.theater_name)
      report.page.item(:performance).value(p.name)
    end

    send_data report.generate, filename: 'printlogs_' + mystart.strftime('%Y_%m_%d') + '.pdf',
                               type: 'application/pdf',
                               disposition: 'attachment'
  end
end
