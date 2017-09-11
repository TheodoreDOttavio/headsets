class VentriesController < ApplicationController
  def index
    administratorsOnly

    if params[:mystart] then
      @mystart = params[:mystart].to_date
    else
      @mystart = weekstart
    end

    show = Distributed.nextEmptySheet(@mystart).last
    @showname =  show.performance.name
    @showid =  show.performance.id

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

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6).strftime('%b %d, %Y')

    require 'fileutils'

    jpegfilelist = Dir.glob('app/assets/images/ftp/*.jpg')
    @thisimage = 'ftp/' + jpegfilelist.first.split('/').last
  end


  def new
    #submit data - and reload ventries#index
    flash[:success] = 'Done - week of ### for show ### Added.'
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
    end
    flash[:success] += params.inspect

    redirect_to ventry_path
  end

  # t.integer  "performance_id",                 null: false
  # t.integer  "language",                     null: false
  # t.datetime "curtain",                        null: false
  # t.boolean  "eve",            default: true
  # t.integer  "quantity"
  # t.integer  "language",       default: 0,     null: false
  # t.integer  "general",        default: 0
  # t.integer  "representative", default: 0
  # t.datetime "created_at"
  # t.datetime "updated_at"
  # t.boolean  "isinfrared",     default: false
  # t.boolean  "scan",           default: false

end
