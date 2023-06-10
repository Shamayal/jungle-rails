require 'rails_helper'

RSpec.describe Product, type: :model do

  before do
    @category = Category.new(name: 'Flowers')
    @category.save
  end

  describe 'Validations' do

    it 'should save a new product with all 4 required fields present' do
      @product = Product.new(name: 'Hibiscus', price: '60', quantity: 2, category: @category)
      @product.save

      expect(@product.save).to be true
    end

    it 'should show an error if the name is not set' do
      @product = Product.new(name: nil, price: '60', quantity: 2, category: @category)
      @product.save

      expect(@product.errors.full_messages).to include("Name can't be blank")
    end

    it 'should show an error if the price is not set' do
      @product = Product.new(name: 'Hibiscus', price_cents: nil, quantity: 2, category: @category)
      @product.save

      expect(@product.errors.full_messages).to include("Price can't be blank")
    end
      
    it 'should show an error if the quantity is not set' do
      @product = Product.new(name: 'Hibiscus', price: '60', quantity: nil, category: @category)
      @product.save
  
      expect(@product.errors[:quantity]).to_not be_empty
    end
  
    it 'should show an error if the category is not set' do
      @product = Product.new(name: 'Hibiscus', price: '60', quantity: 2, category: nil)
      @product.save
  
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end

  end
end