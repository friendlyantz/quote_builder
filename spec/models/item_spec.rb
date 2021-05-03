require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '.validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:individual_cost) }
  end
end
