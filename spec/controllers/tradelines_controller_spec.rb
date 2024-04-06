require 'rails_helper'

RSpec.describe TradelinesController, type: :controller do
  describe '#index' do
    let!(:tradeline) { FactoryBot.create :tradeline }
    let!(:deposits) { FactoryBot.create_list(:deposit, 3, deposit_date: Date.tomorrow, tradeline: tradeline) }

    before(:each) do
      get :index
      @response = response
      @response_body = JSON.parse response.body
    end

    it 'responds with a 200' do
      expect(@response).to have_http_status(:ok)
    end

    it 'response body includes outstanding_balance' do
      expect(@response_body[0]['outstanding_balance']).to eq(tradeline.reload.outstanding_balance.to_s)
    end

    it 'response body includes deposits' do
      deposits = JSON.parse tradeline.reload.deposits.to_json
      expect(@response_body[0]['deposits']).to eq(deposits)
    end
  end

  describe '#show' do
    let(:tradeline) { FactoryBot.create :tradeline }
    let!(:deposits) { FactoryBot.create_list(:deposit, 3, deposit_date: Date.tomorrow, tradeline: tradeline) }

    context 'when request is successful' do
      before(:each) do
        get :show, params: { id: tradeline.id }
        @response = response
        @response_body = JSON.parse(response.body)
      end

      it 'responds with a 200' do
        expect(@response).to have_http_status(:ok)
      end

      it 'response body includes outstanding_balance' do
        expect(@response_body['outstanding_balance']).to eq(tradeline.reload.outstanding_balance.to_s)
      end

      it 'response body includes deposits' do
        deposits = JSON.parse tradeline.reload.deposits.to_json
        expect(@response_body['deposits']).to eq(deposits)
      end
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 1000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
