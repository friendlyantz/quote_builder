require 'rails_helper'

RSpec.describe QuoteProductDecorator, type: :decorator do
  let(:plural_book_line_quote) { QuoteProduct.new(amount: 2, item: build(:book)).decorate }
  let(:singular_book_line_quote) { QuoteProduct.new(amount: 1, item: build(:book)).decorate }

  it 'returns plural "Books" if amount is 2+' do
    expect(plural_book_line_quote.name).to eq('Books')
  end

  it 'returns singular "Book" amount is 1' do
    expect(singular_book_line_quote.name).to eq('Book')
  end
end
