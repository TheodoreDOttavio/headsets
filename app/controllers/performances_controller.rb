class PerformancesController < ApplicationController
  def index
    if params[:current] == '1'
      @title = 'Now Showing'
      @performances = Performance.nowshowing.paginate(page: params[:page]).order(:name)
    else
      @title = 'All Shows'
      @performances = Performance.paginate(page: params[:page]).order(:name)
    end
  end

  def show
    @performance = Performance.find(params[:id])
  end

  def new
    @performance = Performance.new
    @anopeningdate = weekstart
  end

  def create
    @performance = Performance.new(performance_params)
    if @performance.save
      flash[:success] = 'A new Show has been added!'
      redirect_to performances_path
    else
      render 'new'
    end
  end

  def edit
    @performance = Performance.find(params[:id])
    mylastDistributed = Distributed.select(:curtain).where('performance_id = ?', @performance.id).order(:curtain)
    @mylastDistributed = if mylastDistributed.count == 0
                           weekstart
                         else
                           mylastDistributed.last.curtain
                         end
  end

  def update
    @performance = Performance.find(params[:id])
    if @performance.update_attributes(performance_params)
      flash[:success] = 'Show Information has been Updated'
      redirect_to performances_path(current: 1)
    else
      render 'edit'
    end
  end

  def destroy
    @performance = Performance.find(params[:id])
    Performance.find(params[:id]).destroy
    flash[:success] = @performance.name + ' has been Deleted.'
    redirect_to performances_path
  end

  private

  def performance_params
    params.require(:performance).permit(:name,
                                        :theater_id,
                                        :duration,
                                        :intermission,
                                        :opening,
                                        :closeing,
                                        :comments,
                                        :specialservices,
                                        users_attributes: [:id,
                                                           :name],
                                        cabinets_attributes: [:id,
                                                              :theater_id,
                                                              :product_id,
                                                              :quantity],
                                        products_attributes: [:id,
                                                              :name,
                                                              :payrate,
                                                              :options,
                                                              :comments])
  end
end
