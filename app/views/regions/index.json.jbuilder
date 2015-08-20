json.array!(@regions) do |region|
  json.extract! region, :id, :region
  json.url region_url(region, format: :json)
end
