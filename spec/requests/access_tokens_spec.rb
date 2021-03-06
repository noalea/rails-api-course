require 'rails_helper'

RSpec.describe AccessTokensController do
  describe "#create" do
    shared_examples_for 'unauthorized_requests' do
      let(:error) do
        {
          "status": "401",
          "source": { "pointer": "/code" },
          "title":  "Authentication code is invalid",
          "detail": "You must provide valid code in order to exchange it for token."
        }
      end

      it 'should return status code 401' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        subject
        expect(json[:errors]).to include(error)
      end
    end

    context 'when no code provided' do 
      subject { post '/login' }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when invalid code provided' do 
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(github_error)
      end

      subject { post '/login', params: { code: 'invalid_code' } }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when successful request' do
      let(:user_data) do
        {
          login: 'janedoe-1',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avatar',
          name: 'Jane Doe'
        }
      end
      
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('validaccesstoken')
          
        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end
          
      subject { post '/login', params: { code: 'valid_code' } }

      it 'should return 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should return proper json body' do
        expect{ subject }.to change{ User.count }.by(1)
        user = User.find_by(login: 'janedoe-1')
        token = user.access_token
        expect(json_data[:attributes][:token]).to eq(user.access_token.token)
      end
    end
  end
end
