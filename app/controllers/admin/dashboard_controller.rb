class Admin::DashboardController < ApplicationController

  http_basic_authenticate_with name: ENV['HTTP_BASIC_USER'], password: ENV['HTTP_BASIC_PASSWORD']

  def show
    @products_count = Product.count
    @categories_count = Category.count
  end
end
