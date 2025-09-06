class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    query = params[:query]
    @products = Product.find_by_sql("SELECT * FROM products WHERE name LIKE '%#{query}%'")
    # @products = Product.where("name LIKE '%#{query}%'")
    # sanitized_query = Product.sanitize_sql_like(query)
    # @products = Product.where("name LIKE ?", "%#{sanitized_query}%")
    render :index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'Product added successfully.'
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :img_url)
  end
end
