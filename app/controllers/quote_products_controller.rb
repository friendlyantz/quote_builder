class QuoteProductsController < ApplicationController
  def new
    @quote_product = QuoteProduct.new
  end

  def create
    @quote_product = QuoteProduct.new(quote_product_params)
    @quote_product.quote_id = params[:quote_id]

    if @quote_product.save
      redirect_to @quote_product.quote, notice: 'Quote product was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    QuoteProduct.find(params[:id]).destroy
    redirect_to Quote.find(params[:quote_id]), notice: 'Quote product was successfully removed.'
  end

  private

  def quote_product_params
    params.require(:quote_product).permit(:quote_id, :product, :amount)
  end
end
