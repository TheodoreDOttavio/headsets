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

    #TODO We know the logtype... so categories for headset/loop vs. SS languages
    # @productCats = []
    # productCats = Shortlists.new.productCategories
    # productCats.each do |key, value|
    #   @productCats.push([value, key])
    # end

    @languages = [] #["Theater Audio", 0]
    languages = Shortlists.new.languages
    languages.each do |key, value|
      @languages.push([key.to_s, value]) if value >= 1
    end

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6.days).strftime('%b %d, %Y')
  end


  def new
    #submit data - and reload ventries#index
    # flash[:success] = "" + params[:task] + "<br>"
    #TODO rethink this.. adding languages needs a check for last one:Done

    case params[:task]
    when "Data"
      for i in 0..(params[:shiftcount].to_i)-1 do
        obj = Distributed.new()
        obj.performance_id = params[:showid].to_i
        obj.product_id = params[:productCat].to_i

        obj.language = params[:language].to_i
        case params[:productCat].to_i
        when 10, 20
          obj.language = 0
          obj.isinfrared = true
        when 30
          obj.language = 2
        when 40
          obj.language = 1
        end

        rowname = 'ventry' + i.to_s
        obj.curtain = params[:mystart].to_date + params[rowname][:weekday].to_i
        obj.eve = params[rowname][:eve]
        obj.quantity = params[rowname][:qty]
        # obj.save
      end
      # Add isprocesed flag to scans
      scanobj = Scan.find(params[:myscan])
      scanobj.isprocessed = true
      # scanobj.save
      flash[:success] = "Week of #{params[:mystart].to_date.strftime('%b %d')} for show #{params[:showid]} Added.<br>"
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
      movefile = findlog(scanobj.monday, scanobj.id, ss)
      flash[:success] = "Moved : " + movefile.to_s + "<br>"
      # require 'fileutils'
      # FileUtils.mv myfile, myplacedpath + myplacedfile
    # when "Extra"
    end

    # flash[:success] += i.to_s + " for this:   " + params.inspect

    redirect_to ventry_path
  end


end
