# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @reviews = Review.all
  end
end
