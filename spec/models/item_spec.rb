require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { described_class.new(name: 'Product', individual_cost: 3) }

  it 'has a name' do
    expect(subject.name).to eq('Product')
  end

  describe '.validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:individual_cost) }
  end

  context 'with Factory Girl/Bot builds' do
    let(:book) { build(:book) }

    it 'Represents Book' do
      expect(book.name).to eq('Book')
    end

    it 'Book has initial cost' do
      expect(book.individual_cost).not_to eq(nil)
    end

    it 'Book has a tax rate of 10%' do
      expect(book.tax_rate).to eq(0.1)
    end

    it 'Book has an import duty rate of 5%' do
      expect(book.import_duty_rate).to eq(0.05)
    end
  end
end
