require 'rails_helper'

RSpec.describe Tradeline, type: :model do
  let(:tradeline) { FactoryBot.create :tradeline }
  let!(:deposits) { FactoryBot.create_list(:deposit, 3, deposit_date: Date.tomorrow, tradeline: tradeline) }

  describe '#total_deposit_amount' do
    it 'returns the sum of all deposit amounts on the tradeline' do
      total_deposit_amount = 0
      deposits.each do |deposit|
        total_deposit_amount += deposit.amount
      end

      expect(tradeline.reload.total_deposit_amount).to eq(total_deposit_amount)
    end
  end

  describe '#outstanding_balance' do
    it 'returns the remaining balance on a tradeline' do
      total_deposit_amount = deposits.sum{ |deposit| deposit.amount }
      expect(tradeline.reload.outstanding_balance).to eq(tradeline.amount - total_deposit_amount)
    end
  end
end
