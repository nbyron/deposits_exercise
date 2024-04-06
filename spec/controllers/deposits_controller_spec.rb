require 'rails_helper'

RSpec.describe DepositsController, type: :controller do
  describe '#index' do
    let(:tradeline) { FactoryBot.create :tradeline }
    let!(:deposits) { FactoryBot.create_list(:deposit, 3, deposit_date: Date.tomorrow, tradeline: tradeline) }

    context 'when request is successful' do
      before(:each) do
        get :index, params: { tradeline_id: tradeline.id }
        @response = response
        @response_body = JSON.parse response.body
      end

      it 'responds with a 200' do
        expect(@response).to have_http_status(:ok)
        expect(@response_body.length).to eq(deposits.length)
      end
    end

    context 'when request is not successful' do
      context 'if the tradeline is not found' do
        it 'responds with a 404' do
          get :index, params: { tradeline_id: 1000 }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe '#show' do
    let(:tradeline) { FactoryBot.create :tradeline }
    let!(:deposits) { FactoryBot.create_list(:deposit, 3, deposit_date: Date.tomorrow, tradeline: tradeline) }

    context 'when request is successful' do
      before(:each) do
        get :show, params: { tradeline_id: tradeline.id, id: deposits.first.id }
        @response = response
        @response_body = JSON.parse(response.body)
      end

      it 'responds with a 200' do
        expect(@response).to have_http_status(:ok)
      end
    end

    context 'when request is not successful' do
      context 'if the deposit is not found' do
        it 'responds with a 404' do
          get :show, params: { tradeline_id: tradeline.id, id: 1000 }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe '#create' do
    let(:tradeline) { FactoryBot.create :tradeline }

    context 'when request is successful' do
      before(:each) do
        get :create, params: {
          tradeline_id: tradeline.id,
          deposit: { deposit_date: Date.tomorrow, amount: 10.00 }
        }
        @response = response
        @response_body = JSON.parse(response.body)
      end

      it 'responds with a 201' do
        expect(@response).to have_http_status(:created)
      end

      it 'renders created deposit' do
        expect(@response_body).to include('id', 'tradeline_id', 'deposit_date', 'amount', 'created_at', 'updated_at')
      end
    end

    context 'when request is not successful' do
      context 'if deposit_date is a past date' do
        it 'responds with a 400' do
          get :create, params: {
            tradeline_id: tradeline.id,
            deposit: { deposit_date: Date.yesterday, amount: 10.00 }
          }
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'if deposit amount is greater than tradeline outstanding balance' do
        it 'responds with a 400' do
          get :create, params: {
            tradeline_id: tradeline.id,
            deposit: { deposit_date: Date.yesterday, amount: 100000.00 }
          }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
