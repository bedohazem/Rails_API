module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]
      before_action :require_admin!, only: %i[create update destroy]

      def index
        products = Product.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)

        render json: {
          data: products.as_json(only: %i[id name price created_at]),
          meta: {
            page: products.current_page,
            per_page: products.limit_value,
            total_pages: products.total_pages,
            total_count: products.total_count
          }
        }
      end

      def show
        render json: @product
      end

      def create
        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :price)
      end
    end
  end
end
