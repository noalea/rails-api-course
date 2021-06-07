require 'rails_helper'

RSpec.describe AccessTokensController do
  describe "#create" do
    context 'when invalid request' do 
      let(:error) do
        {
          "status": "401",
          "source": { "pointer": "/code" },
          "title":  "Authentication code is invalid",
          "detail": "You must provide valid code in order to exchange it for token."
        }
      end

      subject { post '/login' }

      it 'should return status code 401' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        subject
        expect(json[:errors]).to include(error)
      end
    end

    context 'when successful request' do

    end
  end
end
