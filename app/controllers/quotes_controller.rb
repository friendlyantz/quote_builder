# frozen_string_literal: true #FIXME trust this is for handling rubocop error intended to prepare users for Ruby 3.0 frozen string. this check skipped in rubocop.yml

class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy]

  # GET /quotes #FIXME unnecessary comments for CRUD app
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1 #FIXME unnecessary comments for CRUD app
  def show
    @quote = @quote.decorate
  end

  # GET /quotes/new #FIXME unnecessary comments for CRUD app
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit #FIXME unnecessary comments for CRUD app
  def edit; end

  # POST /quotes #FIXME unnecessary comments for CRUD app
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /quotes/1 #FIXME unnecessary comments for CRUD app
  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: 'Quote was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quotes/1 #FIXME unnecessary comments for CRUD app
  def destroy
    @quote.destroy
    redirect_to quotes_url, notice: 'Quote was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions. #FIXME unnecessary comments for CRUD app
  def set_quote #FIXME poor naming. find_quote would be more appropriate
    @quote = Quote.find(params[:id])
  end

  # Only allow a list of trusted parameters through. #FIXME unnecessary comments for CRUD app
  def quote_params
    params.require(:quote).permit(:title, :email)
  end
end
