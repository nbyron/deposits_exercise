class DepositsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    render json: Tradeline.find(params[:tradeline_id]).deposits
  end

  def show
    render json: Deposit.find(params[:id])
  end

  def create
    begin
      @deposit = Deposit.new(deposit_params)
      @deposit.save!
      render status: 201, json: @deposit
    rescue StandardError => e
      render status: 400, json: { message: e.to_s }
    end
  end

  private

  def not_found
    render json: 'not_found', status: :not_found
  end

  def deposit_params
    params.require(:deposit).permit(:amount, :deposit_date).merge(tradeline_id: params[:tradeline_id])
  end
end
