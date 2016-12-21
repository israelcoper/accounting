class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_account.products
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params.merge(account: current_account, product_type: Product.product_types[product_type]))
    if @product.save
      flash[:notice] = "#{@product.name} was successfully created"
      redirect_to account_products_path(current_account)
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

  # current default product type
  def product_type
    params[:product_type] ||= "rice"
  end
  helper_method :product_type

  def product_params
    params.require(:product).permit(:product_type, :name).tap do |whitelist|
      whitelist[:fields] = params[:product][:fields]
    end
  end

  def find_product
    @product ||= Product.find(params[:id])
  end

end
