class VentriesController < ApplicationController
  def index
    redirect_to root_url unless current_user.admin?

    if params[:mystart] then
      @mystart = params[:mystart].to_date
    else
      @mystart = weekstart
    end

    show = Distributed.nextEmptySheet(@mystart).last
    @showname =  show.performance.name

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6).strftime('%b %d, %Y')

    require 'fileutils'

    jpegfilelist = Dir.glob('app/assets/images/ftp/*.jpg')
    @thisimage = 'ftp/' + jpegfilelist.first.split('/').last
  end

  def new
    #submit data - and reload ventries#index
    flash[:success] = 'Done - week of ### for show ### Added.'
    redirect_to ventry_path
  end
end
