json.array!(@newsitems) do |newsitem|
  json.extract! newsitem, :id, :item, :source
  json.url newsitem_url(newsitem, format: :json)
end
