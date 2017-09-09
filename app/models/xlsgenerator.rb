class Xlsgenerator
  def initialize; end

  def cleanup(folder, file)
    require 'fileutils'
    FileUtils.rm Dir.glob(folder + file)
  end

  def createflatfile(folder, file)
    # to create MS Excell files
    require 'fileutils'
    require 'rubygems'

    langlist = Shortlists.new.languages
    distributed = Distributed.order(:curtain, :eve, :performance_id, :product_id)

    workbook = WriteExcel.new(folder + file)
    worksheet = workbook.add_worksheet

    # define formats for spreadsheet
    headerformat = workbook.add_format
    headerformat.set_font('Ariel')
    headerformat.set_size(11)
    headerformat.set_bold
    headerformat.set_color('black')
    headerformat.set_align('center')

    dataformat = workbook.add_format
    dataformat.set_font('Ariel')
    dataformat.set_size(11)
    dataformat.set_color('black')
    dataformat.set_align('left')

    numberformat = workbook.add_format
    numberformat.set_font('Ariel')
    numberformat.set_size(11)
    numberformat.set_color('black')
    numberformat.set_align('center')

    # set colums, row widths, and print settings
    worksheet.set_column('A:A', 21)
    worksheet.set_column('B:B', 30)
    worksheet.set_column('C:C', 11)
    worksheet.set_column('D:D', 4)
    worksheet.set_column('E:E', 17)
    worksheet.set_column('F:F', 4)
    worksheet.set_portrait
    worksheet.set_paper(1) # US letter size
    worksheet.center_horizontally

    # Write Headers
    worksheet.write(0, 0, 'Theater', headerformat)
    worksheet.write(0, 1, 'Performance', headerformat)
    worksheet.write(0, 2, 'Device', headerformat)
    worksheet.write(0, 3, 'QTY', headerformat)
    worksheet.write(0, 4, 'Date', headerformat)
    worksheet.write(0, 5, 'Shift', headerformat)

    distributed.each_with_index do |record, counter|
      worksheet.write(counter + 1, 0, record.performance.theater.name, dataformat)
      worksheet.write(counter + 1, 1, record.performance.name, dataformat)
      if record.product_id == 3 || record.product_id == 7
        worksheet.write(counter + 1, 2, 'Loop', dataformat)
      else
        worksheet.write(counter + 1, 2, langlist.key(record.language), dataformat)
      end
      worksheet.write(counter + 1, 3, record.quantity, numberformat)
      worksheet.write(counter + 1, 4, record.curtain.strftime('%a %b %-d, %Y'), numberformat)
      if record.eve
        worksheet.write(counter + 1, 5, 'Eve', dataformat)
      else
        worksheet.write(counter + 1, 5, 'Mat', dataformat)
      end
    end

    # write excell sheet to file
    workbook.close
  end

  def generatemonthly(mystart, exporttheater)
    # to create MS Excell files
    require 'fileutils'
    require 'rubygems'

    # mystart = params[:xportmonthstart].to_date

    myend = (mystart + 1.months) - 1.days

    @monthof = mystart.strftime('%b - %Y')

    # FileUtils.rm Dir.glob("app/reports/month-by-theater_" + mystart.strftime('%b_%Y') + ".zip")

    # The performance list comes from distributed so closed shows, and no data shows are not included
    #  but... now chop down the remaining to limit by Theater company or theater
    case exporttheater.to_f
    when 1 # all theaters
      performancelist = Distributed.allperformances(mystart, myend)
    when 0 # use theater company
      theater = Theater.where(company: exporttheater)
      performancelist = []
      theater.each do |t|
        performancelist.push(t.performance.id) unless t.performance.nil?
      end
    else # theater_id was passed
      thistheaterid = exporttheater.to_f
      theater = Theater.find(thistheaterid)
      if theater.performance.nil?
        theater = Theater.where(company: exporttheater)
        flash[:error] = 'No Data Found for ' + theater.name
        redirect_to papers_path
      else
        performancelist = Distributed.oneperformance(mystart, myend, theater)
      end
    end

    unless performancelist.nil?
      # Make an exel doc for each theater
      performancelist.each do |p|
        @performance = Performance.find(p)
        @theater = Theater.find(@performance.theater_id)
        @distributeds = Distributed.infrared_for_oneperformance(mystart, myend, p)

        infrared = []
        translation = []
        icapdesc = []
        curtainlist = []

        # create excel file and spreadsheet
        # this writes everytime page is displayed to accomodate all changes and keep the link fresh
        workbook = WriteExcel.new('app/reports/monthbytheater/' + @theater.name + '_' + mystart.strftime('%b_%Y') + '.xls')
        worksheet = workbook.add_worksheet

        # define formats for spreadsheet
        headerformat = workbook.add_format
        headerformat.set_font('Ariel')
        headerformat.set_size(12)
        headerformat.set_bold
        headerformat.set_color('blue')
        headerformat.set_align('left')

        keyformat = workbook.add_format
        keyformat.set_font('Times New Roman')
        keyformat.set_size(12)
        keyformat.set_color('black')
        keyformat.set_align('center')

        dayformat = workbook.add_format
        dayformat.set_font('Ariel')
        dayformat.set_size(11)
        dayformat.set_color('black')
        dayformat.set_align('left')

        dataformat = workbook.add_format
        dataformat.set_font('Times New Roman')
        dataformat.set_size(10)
        dataformat.set_color('black')
        dataformat.set_align('center')

        # set colums and row widths
        worksheet.set_column('A:B', 15)
        worksheet.set_column('C:E', 12)
        worksheet.set_row(0, 24)
        worksheet.print_area('A1:E16')

        # product_id 1 has all shows
        # build three vertical arrays of the quantities because each quantity is a group of product ID's or language ID's
        # The myspacer is for end of weektotals that move the rows down Starts at 2 for row 3
        myspacer = 2
        yesterdaywas = 'Mon'
        toprowforweektotal = 3

        @distributeds.each_with_index do |u, ui|
          # is this entry going to be the first show of the week?
          #  if yesterday (last entry) was Fri, Sat or Sun then
          #  if this entry is Mon, Tue, or Wed... it IS - add two rows before continuing.
          sotodayis = u.curtain.strftime('%a')

          if (yesterdaywas == 'Fri') || (yesterdaywas == 'Sat') || (yesterdaywas == 'Sun')
            if (sotodayis == 'Mon') || (sotodayis == 'Tue') || (sotodayis == 'Wed')
              worksheet.write(ui + myspacer, 1, 'Week Totals', keyformat)
              worksheet.write(ui + myspacer, 2, '=SUM(C' + toprowforweektotal.to_s + ':C' + (ui + myspacer).to_s + ')', keyformat)
              worksheet.write(ui + myspacer, 3, '=SUM(D' + toprowforweektotal.to_s + ':D' + (ui + myspacer).to_s + ')', keyformat)
              worksheet.write(ui + myspacer, 4, '=SUM(E' + toprowforweektotal.to_s + ':E' + (ui + myspacer).to_s + ')', keyformat)
              worksheet.set_row(ui + myspacer + 1, 6)

              myspacer += 2
              toprowforweektotal = ui + myspacer + 1
            end
          end
          yesterdaywas = u.curtain.strftime('%a')

          if u.eve == false
            worksheet.write(ui + myspacer, 0, u.curtain.strftime('%A') + ' mat', dayformat)
          else
            worksheet.write(ui + myspacer, 0, u.curtain.strftime('%A') + ' eve', dayformat)
          end

          worksheet.write(ui + myspacer, 1, u.curtain.strftime('%m/%d/%Y'), dataformat)

          curtainlist.push([u.curtain, u.eve])

          # build up placeholder arrays for nil qty's...
          infrared.push(0)
          translation.push(0)
          icapdesc.push(0)

          # and drop in the week totals at the end:
          if ui == @distributeds.count - 1
            worksheet.write(ui + myspacer + 1, 1, 'Week Totals', keyformat)
            worksheet.write(ui + myspacer + 1, 2, '=SUM(C' + toprowforweektotal.to_s + ':C' + (ui + myspacer + 1).to_s + ')', keyformat)
            worksheet.write(ui + myspacer + 1, 3, '=SUM(D' + toprowforweektotal.to_s + ':D' + (ui + myspacer + 1).to_s + ')', keyformat)
            worksheet.write(ui + myspacer + 1, 4, '=SUM(E' + toprowforweektotal.to_s + ':E' + (ui + myspacer + 1).to_s + ')', keyformat)
          end

          # Set the print Area and page formating
          worksheet.set_portrait
          worksheet.set_paper(1) # US letter size
          worksheet.center_horizontally
          worksheet.print_area(0, 0, ui + myspacer + 1, 4)
        end

        # infrared - add loops, and sanhausers product ID 1,3,6,7
        curtainlist.each_with_index do |_u, ui|
          @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).infrared
          myqty = 0
          @distributeds.each do |d|
            myqty += d.quantity
          end
          infrared[ui] = infrared[ui] + myqty
        end

        # translations product ID 4,5 where languageID > 0
        curtainlist.each_with_index do |_u, ui|
          @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).translation
          myqty = 0
          @distributeds.each do |d|
            myqty += d.quantity
          end
          translation[ui] = translation[ui] + myqty
        end

        # I-Cap & D.S product ID 4,5 where languageID = 0
        curtainlist.each_with_index do |_u, ui|
          @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).icapdesc
          myqty = 0
          @distributeds.each do |d|
            myqty += d.quantity
          end
          icapdesc[ui] = icapdesc[ui] + myqty
        end

        # fill vertical colums
        # The myspacer is for end of weektotals that move the rows down Starts at 2 for row 3
        myspacer = 2
        yesterdaywas = 'Mon'

        infrared.each_with_index do |_qty, qtyi|
          sotodayis = curtainlist[qtyi][0].strftime('%a')
          if (yesterdaywas == 'Fri') || (yesterdaywas == 'Sat') || (yesterdaywas == 'Sun')
            if (sotodayis == 'Mon') || (sotodayis == 'Tue') || (sotodayis == 'Wed')
              myspacer += 2
            end
          end
          yesterdaywas = curtainlist[qtyi][0].strftime('%a')

          worksheet.write(qtyi + myspacer, 2, infrared[qtyi], dataformat)
          worksheet.write(qtyi + myspacer, 3, translation[qtyi], dataformat)
          worksheet.write(qtyi + myspacer, 4, icapdesc[qtyi], dataformat)
        end

        # Static fields
        worksheet.write(0, 0, ' ' + @performance.name.upcase + ' - ' + @monthof, headerformat)
        worksheet.write(1, 2, 'Infrared', keyformat)
        worksheet.write(1, 3, 'Translation', keyformat)
        worksheet.write(1, 4, 'I-Cap & D.S', keyformat)

        # write excell sheet to file
        workbook.close
      end
   end # end performance.nil?
  end

  def generatemonthlyss(performance, year)
    # to create MS Excell files
    require 'fileutils'
    require 'rubygems'

    thisperformance = Performance.find(performance)
    langlist = Shortlists.new.languages.slice!(:Infrared).slice!(:iCaption).slice!(:dScript).slice!(:Turkish)

    monthstarts = Distributed.monthsbymondays(year)
    folder = 'app/reports/monthbytheater/'
    file = thisperformance.name + '-special-services.xls'

    # clean up... remove existing xls files
    FileUtils.rm Dir.glob(folder + '*-special-services.xls')

    workbook = WriteExcel.new(folder + file)
    worksheet = workbook.add_worksheet

    # define formats for spreadsheet
    titleformat = workbook.add_format
    titleformat.set_font('Ariel')
    titleformat.set_size(14)
    titleformat.set_color('black')
    titleformat.set_align('left')

    headerformat = workbook.add_format
    headerformat.set_font('Ariel')
    headerformat.set_size(11)
    headerformat.set_bold
    headerformat.set_color('black')
    headerformat.set_align('center')

    dataformat = workbook.add_format
    dataformat.set_font('Ariel')
    dataformat.set_size(11)
    dataformat.set_color('black')
    dataformat.set_align('center')

    # set colums, row widths, and print settings
    worksheet.set_column('A:A', 21.43)
    worksheet.set_column('B:I', 14.43)
    worksheet.set_row(0, 27.75)
    for i in 1..18 do
      worksheet.set_row(i, 21)
    end
    worksheet.print_area('A1:F17')
    worksheet.set_portrait
    worksheet.set_paper(1) # US letter size
    worksheet.center_horizontally

    # Write Headers
    worksheet.write(0, 0, thisperformance.name.upcase + ' - Translation Reports - ' + year, titleformat)
    worksheet.write(2, 0, 'MONTH (Mon-Sun)', headerformat)
    worksheet.write(2, langlist.count + 1, 'TOTALS', headerformat)
    worksheet.write(15, 0, 'TOTALS', headerformat)

    monthstarts.each_with_index do |wk, r|
      worksheet.write(3 + r, 0, wk[0].strftime('%m/%d/%y') + ' - ' + wk[1].strftime('%m/%d/%y'), dataformat)

      myascii = 65 # "A"
      langlist.each_with_index do |l, x|
        thiscount = Distributed.language_for_oneperformance(wk[0], wk[1], l[1], thisperformance.id)
        if thiscount != 0
          worksheet.write(3 + r, x + 1, thiscount.sum(:quantity), dataformat)
        end
      end
      myascii += langlist.count
      worksheet.write(3 + r, langlist.count + 1, '=SUM(B' + (4 + r).to_s + ':' + myascii.chr + (4 + r).to_s + ')', headerformat)
    end

    # laguage headers/totals
    myascii = 65 # "A"
    langlist.each_with_index do |l, x|
      col = x + 1
      myascii += 1
      worksheet.write(2, col, l[0], headerformat)
      worksheet.write(15, col, '=SUM(' + myascii.chr + '4:' + myascii.chr + '15)', headerformat)
    end

    # write excell sheet to file
    workbook.close
    end

  def generateweeklyxls(mystart)
    # to create MS Excell files
    require 'fileutils'
    require 'rubygems'
    require 'zip'

    myend = mystart + 7.days

    @weekof = mystart.strftime('%a, %b %d - %Y')

    # clean up... remove existing xls files
    FileUtils.rm Dir.glob('app/reports/weekbytheater/*.xls')
    FileUtils.rm Dir.glob('app/reports/week-by-theater_*.zip')

    performancelist = Distributed.datespan(mystart, myend).distinct(:performance_id).pluck(:performance_id)

    # Make an exel doc for each theater
    performancelist.each_with_index do |p, _pi|
      @performance = Performance.find(p)
      @theater = Theater.find(@performance.theater_id)
      @distributeds = Distributed.datespan(mystart, myend).infrared.where('performance_id = ?', p).order(:curtain, :eve)

      infrared = []
      translation = []
      icapdesc = []
      curtainlist = []

      # create excel file and spreadsheet
      # this writes everytime page is displayed to accomodate all changes and keep the link fresh
      workbook = WriteExcel.new('app/reports/weekbytheater/' + @theater.name + '_' + mystart.strftime('%Y_%m_%d') + '.xls')
      worksheet = workbook.add_worksheet

      # define formats for spreadsheet
      headerformat = workbook.add_format
      headerformat.set_font('Ariel')
      headerformat.set_size(12)
      headerformat.set_bold
      headerformat.set_color('blue')
      headerformat.set_align('left')

      keyformat = workbook.add_format
      keyformat.set_font('Times New Roman')
      keyformat.set_size(12)
      keyformat.set_color('black')
      keyformat.set_align('center')

      dayformat = workbook.add_format
      dayformat.set_font('Ariel')
      dayformat.set_size(11)
      dayformat.set_color('black')
      dayformat.set_align('left')

      dataformat = workbook.add_format
      dataformat.set_font('Times New Roman')
      dataformat.set_size(10)
      dataformat.set_color('black')
      dataformat.set_align('center')

      # set colums and row widths
      worksheet.set_column('A:B', 15)
      worksheet.set_column('C:E', 12)
      worksheet.set_row(0, 24)
      worksheet.print_area('A1:E16')

      # product_id 1 has all shows
      # build three vertical arrays of the quantities because each quantity is a group of product ID's or language ID's
      @distributeds.each_with_index do |u, ui|
        if u.eve == false
          worksheet.write(ui + 2, 0, u.curtain.strftime('%A') + ' mat', dayformat)
        else
          worksheet.write(ui + 2, 0, u.curtain.strftime('%A') + ' eve', dayformat)
        end

        worksheet.write(ui + 2, 1, u.curtain.strftime('%m/%d/%Y'), dataformat)

        curtainlist.push([u.curtain, u.eve])

        infrared.push(0)
        translation.push(0)
        icapdesc.push(0)
      end

      # ###THIS. seems to be assembling the vert colums wrong...

      # infrared - add loops, and sanhausers product ID 1,3,6,7
      curtainlist.each_with_index do |_u, ui|
        @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).infrared
        myqty = 0
        @distributeds.each do |d|
          myqty += d.quantity
        end
        infrared[ui] = infrared[ui] + myqty
      end

      # translations product ID 4,5 where languageID > 0
      curtainlist.each_with_index do |_u, ui|
        @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).translation
        myqty = 0
        @distributeds.each do |d|
          myqty += d.quantity
        end
        translation[ui] = translation[ui] + myqty
      end

      # I-Cap & D.S product ID 4,5 where languageID = 0
      curtainlist.each_with_index do |_u, ui|
        @distributeds = Distributed.where('performance_id = ? AND curtain = ? AND eve = ?', p, curtainlist[ui][0], curtainlist[ui][1]).icapdesc
        myqty = 0
        @distributeds.each do |d|
          myqty += d.quantity
        end
        icapdesc[ui] = icapdesc[ui] + myqty
      end

      # fill vertical colums
      infrared.each_with_index do |_qty, qtyi|
        worksheet.write(qtyi + 2, 2, infrared[qtyi], dataformat)
        worksheet.write(qtyi + 2, 3, translation[qtyi], dataformat)
        worksheet.write(qtyi + 2, 4, icapdesc[qtyi], dataformat)
      end

      # Static fields
      worksheet.write(0, 0, ' ' + @performance.name.upcase + ' - Translations,  + D-Script and I-Cap -  Week of ' + @weekof, headerformat)
      worksheet.write(1, 2, 'Infrared', keyformat)
      worksheet.write(1, 3, 'Translation', keyformat)
      worksheet.write(1, 4, 'I-Cap & D.S', keyformat)

      worksheet.write(14, 1, 'Week Totals', keyformat)
      worksheet.write(14, 2, '=SUM(C3:C13)', dataformat)
      worksheet.write(14, 3, '=SUM(D3:D13)', dataformat)
      worksheet.write(14, 4, '=SUM(E3:E13)', dataformat)

      # Set the print Area and page formating
      worksheet.set_portrait
      worksheet.set_paper(1) # US letter size
      worksheet.center_horizontally
      worksheet.print_area(0, 0, 15, 4)

      # write excell sheet to file
      workbook.close
    end
    end
end
