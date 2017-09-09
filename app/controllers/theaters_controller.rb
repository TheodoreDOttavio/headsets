class TheatersController < ApplicationController
  def show
    @theater = Theater.find(params[:id])
    currentshow = Performance.currentshow(params[:id])

    if currentshow.first.closeing <= DateTime.now
      @current = 'Dark on ' + currentshow.first.closeing.strftime('%b %d, %Y')
    else
      @current = currentshow.first.name.to_s
    end

    @showlist = 'Past Performances'
    currentshow.each do |show|
      @showlist += ' - ' + show.name.to_s
    end
  end

  def index
    @theaters = Theater.select("*, 'no data' as nowshowing").order(:name).paginate(page: params[:page])

    @theaters.map do |t|
      currentshow = Performance.currentshow(t.id)
      next if currentshow.empty?
      if currentshow.first.closeing <= DateTime.now
        current = 'Dark on ' + currentshow.first.closeing.strftime('%b %d, %Y')
      else
        current = currentshow.first.name.to_s
      end

      t.nowshowing = current
    end
  end

  def new
    @theater = Theater.new
    @companies = Shortlists.new.companies
  end

  def create
    @theater = Theater.new(theater_params)
    @companies = Shortlists.new.companies
    if @theater.save
      flash[:success] = 'A new Theater/Venue has been added!'
      redirect_to @theater
    else
      render 'new'
    end
  end

  def edit
    @theater = Theater.find(params[:id])
    @companies = Shortlists.new.companies
    @performances = Performance.all.order(:name)
  end

  def update
    @theater = Theater.find(params[:id])
    @companies = Shortlists.new.companies
    if @theater.update_attributes(theater_params)
      flash[:success] = 'Theater/Venue Information has been Updated'
      redirect_to theaters_path
    else
      render 'edit'
    end
  end

  def destroy
    Theater.find(params[:id]).destroy
    flash[:success] = 'Theater/Venue has been deleted.'
    redirect_to theaters_path
  end

  private

  def theater_params
    params.require(:theater).permit(:name,
                                    :company,
                                    :address,
                                    :city, :state, :zip,
                                    :phone,
                                    :comments,
                                    :commentsentrance,
                                    :commentsworklocation,
                                    :commentslock)
  end
end
