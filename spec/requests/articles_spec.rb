require 'rails_helper'

RSpec.describe ArticlesController do
	describe '#index' do
		it 'returns a success respone' do
			get '/articles'
			# expect(response.status).to eq(200)
			expect(response).to have_http_status(:ok)
		end

		it 'returns a proper json response' do
			article = FactoryBot.create(:article)
			get '/articles'
			body = JSON.parse(response.body).deep_symbolize_keys
			expect(body).to eq(
				data: [
					{
						id: article.id.to_s,
						type: 'articles',
						attributes: {
							title: article.title,
							content: article.content,
							slug: article.slug
						}
					}
				]
			)
		end
	end
end