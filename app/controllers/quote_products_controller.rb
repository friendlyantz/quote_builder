class QuoteProductsController < ApplicationController
  # GET /quotes/1/products/new
  def new
    @quote_product = QuoteProduct.new
  end

  # POST /quotes/1/products
  def create
    @quote_product = QuoteProduct.new(quote_product_params)
    @quote_product.quote_id = params[:quote_id]

    if @quote_product.save
      redirect_to @quote_product.quote, notice: 'Quote product was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1/products/1
  def destroy
    QuoteProduct.find(params[:id]).destroy
    redirect_to Quote.find(params[:quote_id]), notice: 'Quote product was successfully removed.'
  end

  private

  # Only allow a list of trusted parameters through.
  def quote_product_params
    params.require(:quote_product).permit(:quote_id, :product, :amount)
  end
end
