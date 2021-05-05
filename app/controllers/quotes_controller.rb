# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :find_quote, only: %i[show edit update destroy]

  def index
    @quotes = Quote.all
  end

  def show
    @quote = @quote.decorate
  end

  def new
    @quote = Quote.new
  end

  def edit; end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: 'Quote was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_url, notice: 'Quote was successfully destroyed.'
  end

  private

  def find_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:title, :email)
  end
end
