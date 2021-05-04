class QuoteProductsController < ApplicationController
  # GET /quotes/1/products/new #FIXME unnecessary comments for CRUD app
  def new
    @quote_product = QuoteProduct.new
  end

  # POST /quotes/1/products #FIXME unnecessary comments for CRUD app
  def create
    @quote_product = QuoteProduct.new(quote_product_params)
    @quote_product.quote_id = params[:quote_id]

    if @quote_product.save
      redirect_to @quote_product.quote, notice: 'Quote product was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1/products/1 #FIXME unnecessary comments for CRUD app
  def destroy
    QuoteProduct.find(params[:id]).destroy
    redirect_to Quote.find(params[:quote_id]), notice: 'Quote product was successfully removed.'
  end

  private

  # Only allow a list of trusted parameters through. #FIXME unnecessary comments for CRUD app
  def quote_product_params
    params.require(:quote_product).permit(:quote_id, :product, :amount, :item_id)
  end
end
