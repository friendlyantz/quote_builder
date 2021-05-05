require 'rails_helper'

RSpec.describe QuoteDecorator do
  let(:quote) { Quote.new(email: 'test@test.com', title: 'title').decorate }

  it 'returns plural "Books' do
    expect(quote).to be_decorated
  end
end
