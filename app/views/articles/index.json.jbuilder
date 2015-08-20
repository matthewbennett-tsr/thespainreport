json.array!(@articles) do |article|
  json.extract! article, :id, :headline, :lede, :body
  json.url article_url(article, format: :json)
end
