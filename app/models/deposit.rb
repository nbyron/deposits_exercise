class Deposit < ApplicationRecord
  belongs_to :tradeline

  validates :deposit_date, comparison: { greater_than_or_equal_to: Date.today}
  validate :amount_does_not_exceed_outstanding_balance

  def amount_does_not_exceed_outstanding_balance
    if amount >= tradeline.outstanding_balance
      errors.add :base, 'Deposit amount cannot exceed tradeline outstanding balance'
    end
  end
end
