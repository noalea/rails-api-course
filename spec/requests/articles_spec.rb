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
			expect(json_data.length).to eq(1)
			expected = json_data.first
			aggregate_failures do
				expect(expected[:id]).to eq(article.id.to_s)
				expect(expected[:type]).to eq('articles')
				expect(expected[:attributes]).to eq(
					title: article.title,
					content: article.content,
					slug: article.slug
				)
			end
		end

		it 'returns articles from most recent' do
			older_article = FactoryBot.create(:article, created_at: 1.hour.ago, slug: 'old-article')
			recent_article = FactoryBot.create(:article, slug: 'new-article')
			get '/articles'
			ids = json_data.map { |item| item[:id].to_i }
			expect(ids).to eq([recent_article.id, older_article.id])
		end
	end
end