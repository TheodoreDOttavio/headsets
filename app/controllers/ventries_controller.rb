class VentriesController < ApplicationController
  def index
    administratorsOnly

    show = Scan.unprocessed
    @mystart = show.first.monday #params[:mystart].to_date

    @showname =  Performance.find(show.first.performance_id).name
    @showid =  show.first.performance_id

    @productCats = []
    productCats = Shortlists.new.productCategories
    productCats.each do |key, value|
      @productCats.push([value, key])
    end

    @languages = [["Theater Audio", 0]]
    languages = Shortlists.new.languages
    languages.each do |key, value|
      @languages.push([key.to_s, value]) if value >= 3
    end

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6.days).strftime('%b %d, %Y')
  end


  def new
    #submit data - and reload ventries#index
    flash[:success] = "" + params[:task] + "<br>"

    case params[:task]
    when "Data"
      flash[:success] += "Done - week of #{params[:mystart].to_date.strftime('%b %d')} for show #{params[:showid]} Added.<br>"
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
      #TODO add isprocesed flag to scans
      ss = false
      ss = true if params[:productCat].to_i > 20
      scanobj = Scan.recall(params[:mystart].to_date, params[:showid].to_i, ss)
      # scanobj = Scan.where(monday: params[:mystart].to_date,
      #   specialservices: ss).where("\"scans\".\"performance_id\" = '?'", params[:showid].to_i)
flash[:success] += "---scans found : "
      flash[:success] += scanobj.count.to_s + "<br>"
      # scanobj.save
    when "Blank"
      if params[:productCat].to_i <= 20 then
        flash[:success] += "Enter 0 values for Infrared shifts<br>"
      else
        ss = false
        ss = true if params[:productCat].to_i > 20
        scanobj = Scan.where(monday: params[:mystart].to_date,
          specialservices: ss).where("\"scans\".\"performance_id\" = '?'", params[:showid].to_i)
        # flash[:success] += "id of scan data to change " + scanobj.id.to_s
        # scanobj.save
      end
    when "Move"
      ss = 1
      ss = 2 if params[:productCat].to_i > 20
      movefile = findlog(params[:mystart], params[:showid], ss)
      flash[:success] += "moving : " + movefile.to_s + "<br>"
      # require 'fileutils'
      # FileUtils.mv myfile, myplacedpath + myplacedfile
    # when "Extra"
    end

    flash[:success] += i.to_s + " for this:   " + params.inspect

    redirect_to ventry_path
  end


end
