class ShopController < ApplicationController
  before_action :authenticate_user!

  def index;  end

  def catalog
    @main_categories = Category.all
  end
end
