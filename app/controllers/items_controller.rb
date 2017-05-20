class ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update, :destroy]
  before_action :allocated_to_purchase, only: [:new, :create, :edit, :update]
  before_action :allocated_to_selling, only: [:new, :create, :edit, :update]

  def index
    @items = current_account.items
  end

  def show
    respond_to do |format|
      # format.html
      format.json { render json: @item }
    end
  end

  def new
    @item = Item.new(account: current_account)
    @item.item_number = @item.item_number << (current_account.items.count + 1).to_s
  end

  def create
    @item = Item.new(item_params.merge(account: current_account))
    if @item.save
      flash[:notice] = "#{@item.name} was successfully created"
      redirect_to request.referer
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:notice] = "#{@item.name} was successfully updated"
      redirect_to account_items_path(current_account)
    else
      render :edit
    end
  end

  def destroy
  end

  protected

  def item_params
    params.require(:item).permit(:item_number, :name, :description, :unit, :purchase_price, :selling_price, :allocated_to_purchase, :allocated_to_selling)
  end

  def find_item
    @item ||= Item.find(params[:id])
  end

end
