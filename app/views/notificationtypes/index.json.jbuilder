json.array!(@notificationtypes) do |notificationtype|
  json.extract! notificationtype, :id
  json.url notificationtype_url(notificationtype, format: :json)
end
