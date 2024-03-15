# frozen_string_literal: true

class HomeController < ApplicationController
  def index;  end

  def catalog
    @main_categories = Category.all
  end
end
