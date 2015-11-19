json.array!(@salesemails) do |salesemail|
  json.extract! salesemail, :id
  json.url salesemail_url(salesemail, format: :json)
end
