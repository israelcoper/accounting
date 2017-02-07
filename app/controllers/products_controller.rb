class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_account.products
  end

  def show
    respond_to do |format|
      # format.html
      format.json { render json: @product }
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params.merge(account: current_account))
    if @product.save
      flash[:notice] = "#{@product.name} was successfully created"
      redirect_to request.referer
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "#{@product.name} was successfully updated"
      redirect_to account_products_path(current_account)
    else
      render :edit
    end
  end

  def destroy
  end

  protected

  def product_params
    params.require(:product).permit(:name, :description, :cost, :purchasing_price, :selling_price, :quantity, :unit)
  end

  def find_product
    @product ||= Product.find(params[:id])
  end

end
