class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: 1) # Assuming user_id 1 for simplicity
  end

  # IDOR Vulnerability: No authorization check for accessing orders
  def show
    @order = Order.find(params[:id])
  end

  # IDOR Vulnerability: No authorization check for updating orders
  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to order_path(@order), notice: 'Order updated successfully.'
    else
      render :show
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = 1 # Assuming user_id 1 for simplicity
    if @order.save
      redirect_to orders_path, notice: 'Order created successfully.'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:product_id, :quantity)
  end
end

