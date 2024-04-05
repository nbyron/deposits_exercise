class Tradeline < ApplicationRecord
  has_many :deposits

  def total_deposit_amount
    deposits.sum{ |deposit| deposit.amount }
  end

  def outstanding_balance
    amount - total_deposit_amount
  end
end
