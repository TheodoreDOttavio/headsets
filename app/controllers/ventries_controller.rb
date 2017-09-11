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

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6).strftime('%b %d, %Y')

    require 'fileutils'

    jpegfilelist = Dir.glob('app/assets/images/ftp/*.jpg')
    @thisimage = 'ftp/' + jpegfilelist.first.split('/').last
  end

  def new
    #submit data - and reload ventries#index
    for i in 1..params['shiftcount'].to_i do
      obj = Distributed.new()
      obj.performance_id = params['showid']
      obj.curtain = params['ventry0']['curtain']
      obj.eve = params['ventry0']['eve']
    end
    flash[:success] = 'Done - week of ### for show ### Added.'
    # flash[:success] = params.inspect
    flash[:success] = obj.inspect
    redirect_to ventry_path
  end

  # t.integer  "performance_id",                 null: false
  # t.integer  "product_id",                     null: false
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
