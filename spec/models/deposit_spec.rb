require 'rails_helper'

RSpec.describe Deposit, type: :model do
  let(:tradeline) { FactoryBot.create :tradeline }

  describe 'validations' do
    it 'will raise an error when saving a deposit for a past date' do
      deposit = Deposit.create(tradeline_id: tradeline.id, amount: 10.00, deposit_date: Date.yesterday)
      expect { deposit.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'will raise an error when saving a deposit with an amount greater than tradeline outstanding balance' do
      deposit = Deposit.create(tradeline_id: tradeline.id, amount: 100000.00, deposit_date: Date.tomorrow)
      expect { deposit.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
