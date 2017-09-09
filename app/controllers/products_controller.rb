class ProductsController < ApplicationController
  #  Carries the foreign key for Theaters

  def show
    # profile page for a single product/device
    @product = Product.find(params[:id])
  end

  def index
    @products = Product.paginate(page: params[:page])
  end

  def new
    @options = [['Battery', 0], ['Infrared Receiver', 1], ['Multi Language', 2]]
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'A new Product has been added!'
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
    @options = [['Battery', 0], ['Infrared Receiver', 1], ['Multi Language', 2]]
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success] = @product.name + ' Information has been Updated'
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:success] = @product.name + ' has been Deleted.'
    redirect_to products_path
  end
end
