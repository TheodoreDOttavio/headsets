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
    flash[:success] = params[:task] + "-------"

    # flash[:success] = 'Done - week of ### for show ### Added.'
    for i in 0..(params['shiftcount'].to_i)-1 do
      obj = Distributed.new()
      obj.performance_id = params['showid'].to_i
      obj.product_id = params['productCat'].to_i

      obj.language = params['language'].to_i
      case params['productCat'].to_i
      when 10, 20
        obj.language = 0
        obj.isinfrared = true
      when 30
        obj.language = 2
      when 40
        obj.language = 1
      end

      rowname = 'ventry' + i.to_s
      obj.curtain = params[:mystart].to_date + params[rowname]['weekday'].to_i
      obj.eve = params[rowname]['eve']
      obj.quantity = params[rowname]['qty']
      # obj.save
      #TODO add isprocesed flag to scans
    end
    flash[:success] += i.to_s + " for this:   " + params.inspect

    redirect_to ventry_path
  end


end
