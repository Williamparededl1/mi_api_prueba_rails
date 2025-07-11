# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  # Antes de ejecutar las acciones show, update o destroy,
  # busca el producto por su ID.
  before_action :set_product, only: [ :show, :update, :destroy ]

  # GET /products
  # Responde con una lista de todos los productos
  def index
    @products = Product.all # Obtiene todos los productos de la base de datos
    render json: @products # Convierte la lista de productos a formato JSON y la envía
  end

  # GET /products/:id
  # Responde con un producto específico
  def show
    render json: @product # Convierte el producto encontrado a JSON y lo envía
  end

  # POST /products
  # Crea un nuevo producto
  def create
    @product = Product.new(product_params) # Crea una nueva instancia de Product con los parámetros recibidos

    if @product.save # Intenta guardar el producto en la base de datos
      render json: @product, status: :created, location: @product # Si se guarda, envía el producto creado con status 201 (Created)
    else
      render json: @product.errors, status: :unprocessable_entity # Si falla, envía los errores con status 422 (Unprocessable Entity)
    end
  end

  # PATCH/PUT /products/:id
  # Actualiza un producto existente
  def update
    if @product.update(product_params) # Intenta actualizar el producto con los parámetros recibidos
      render json: @product # Si se actualiza, envía el producto actualizado
    else
      render json: @product.errors, status: :unprocessable_entity # Si falla, envía los errores
    end
  end

  # DELETE /products/:id
  # Elimina un producto
  def destroy
    @product.destroy # Elimina el producto de la base de datos
    head :no_content # Responde con un status 204 (No Content) indicando que se eliminó correctamente
  end

  private

  # Busca un producto por su ID antes de las acciones show, update y destroy
  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound # Maneja el caso si el producto no se encuentra
    render json: { error: "Producto no encontrado" }, status: :not_found
  end

  # Permite solo los parámetros seguros para crear o actualizar un producto
  def product_params
    params.require(:product).permit(:name, :price, :description)
  end
end
