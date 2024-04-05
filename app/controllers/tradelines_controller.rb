class TradelinesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    @tradelines = Tradeline.includes(:deposits)
    render json: @tradelines, include: :deposits, methods: :outstanding_balance
  end

  def show
    @tradeline = Tradeline.find(params[:id])
    render json: @tradeline, include: :deposits, methods: :outstanding_balance
  end

  private

  def not_found
    render json: 'not_found', status: :not_found
  end
end
