require 'rails_helper'

RSpec.describe QuoteProduct, type: :model do
  let(:product) { described_class.new }

  describe '.validations' do
    it { is_expected.to validate_presence_of(:product) }
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe 'cost' do
    context 'when book' do
      before { product.product = :book }

      it 'cost $0.5 plus tax of 10% and import duty 5%' do
        product.amount = 100

        expect(product.cost).to eq(57.5)
      end
    end

    context 'when face_mask' do
      before { product.product = :face_mask }

      it 'cost $1 plus and no tax and import duty 5%' do
        product.amount = 100

        expect(product.cost).to eq(105)
      end
    end

    context 'when first_aid_kit' do
      before { product.product = :first_aid_kit }

      it 'cost $1 plus and no tax and no import duty' do
        product.amount = 100

        expect(product.cost).to eq(1000)
      end
    end
  end
end
