class VentriesController < ApplicationController
  def index
    administratorsOnly

    show = Scan.unprocessed
    @mystart = show.first.monday #params[:mystart].to_date
    @myscan = show.first.id
    @myscanss = 1
    @myscanss = 2 if show.first.specialservices

    @showname =  Performance.find(show.first.performance_id).name
    @showid =  show.first.performance_id

    @languages = [] #["Theater Audio", 0]
    languages = Shortlists.new.languages
    languages.each do |key, value|
      @languages.push([key.to_s, value]) if value >= 1
    end

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6.days).strftime('%b %d, %Y')

    @remaining = Scan.unprocessedCount.count
  end


  def new
    #submit data - and reload ventries#index
    # flash[:success] = "" + params[:task] + "<br>"

    case params[:task]
    when "Data"
      for i in 0..(params[:shiftcount].to_i)-1 do
        obj = Distributed.new()
        obj.performance_id = params[:showid].to_i

        obj.language = params[:language].to_i
        productCat = params[:productCat].to_i

        case params[:language].to_i
        when 1
          productCat = 40
        when 2
          productCat = 30
        end

        case productCat
        when 10
          obj.product_id = 6
          obj.language = 0
          obj.isinfrared = true
        when 20
          obj.product_id = 7
          obj.language = 0
          obj.isinfrared = true
        when 30
          obj.product_id = 4
          # obj.language = 2
        when 40
          obj.product_id = 5
          # obj.language = 1
        when 50
          obj.product_id = 4
        end

        rowname = 'ventry' + i.to_s
        obj.curtain = params[:mystart].to_date + params[rowname][:weekday].to_i.days
        obj.eve = params[rowname][:eve]
        obj.quantity = params[rowname][:qty].to_i
        #No need to save 0 values on anything that is not infrared
        if obj.quantity != 0
          obj.save
        else
          # puts "----------------Zero Qty!"
          if obj.isinfrared == true
            # puts "----------------saving infrared"
            obj.save
          end
        end
      end

      # Add isprocesed flag to scans
      if params[:nextScan] == "true" then
        scanobj = Scan.find(params[:myscan])
        scanobj.isprocessed = true
        scanobj.save
      end

      flash[:success] = "Added #{Product.find(obj.product_id).name} for week of #{params[:mystart].to_date.strftime('%b %d')}.<br>"
      #distributeds/new?action=index&controller=distributeds&mystart= &performance_id=
      flash[:html_safe] = true
      flash[:success] += " <a href='#{root_url}/distributeds/new?action=index&controller=ventries&mystart=#{params[:mystart]}&performance_id=#{params[:showid].to_i}'
      class='btn btn-sm btn-warning'>Review in Editor</a>"

    when "Blank"
      if params[:productCat].to_i <= 20 then
        flash[:error] = "Enter 0 values for Infrared Shifts<br>"
      else
        scanobj = Scan.find(params[:myscan])
        scanobj.isprocessed = true
        scanobj.save
        flash[:success] = "Log marked as processed<br>"
      end
    when "Move"
      scanobj = Scan.find(params[:myscan])
      ss = 1
      ss = 2 if scanobj.specialservices
      myfile = findlog(scanobj.monday, scanobj.performance_id, ss)
      scanobj.destroy

      require 'fileutils'

      FileUtils.mv "app/assets/images/" + myfile, "app/assets/images/ftp/" + myfile.split('/').last
      flash[:success] = "Moved : " + myfile.to_s + "<br>"
    # when "Extra"
    end

    # flash[:success] += i.to_s + " for this:   " + params.inspect

    redirect_to ventry_path
  end


end
