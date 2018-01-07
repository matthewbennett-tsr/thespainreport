json.array!(@images) do |image|
  json.extract! image, :id, :url, :description
  json.url image_url(image, format: :json)
end
