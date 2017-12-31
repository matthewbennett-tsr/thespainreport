json.array!(@briefing_frequencies) do |briefing_frequency|
  json.extract! briefing_frequency, :id, :name, :briefing_frequency
  json.url briefing_frequency_url(briefing_frequency, format: :json)
end
