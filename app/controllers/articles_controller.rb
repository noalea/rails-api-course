class ArticlesController < ApplicationController
	def index
		articles = Article.recent
		render json: serializer.new(articles)
	end

	def serializer
		ArticleSerializer
	end
end