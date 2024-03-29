class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[show edit update destroy]

  def index
    if params[:query].present?
      @pagy, @admin_products = pagy(Product.where("name LIKE ?", "%#{params[:query]}%"))
    else
      @pagy, @admin_products = pagy(Product.all)
    end
  end

  def show;  end

  def new
    @admin_product = Product.new
  end

  def edit
  end

  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_url(@admin_product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @admin_product = Product.find(params[:id])
    if @admin_product.update(admin_product_params.reject { |k| k['images'] })
      if admin_product_params['images']
        admin_product_params['images'].each do |image|
          @admin_product.images.attach(image)
        end
      end
      redirect_to admin_products_path, notice: 'Product updated successfuly'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @admin_product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_product
    @admin_product = Product.find(params[:id])
  end

  def admin_product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
  end
end
