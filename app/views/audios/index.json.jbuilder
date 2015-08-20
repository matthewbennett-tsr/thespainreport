json.array!(@audios) do |audio|
  json.extract! audio, :id, :url
  json.url audio_url(audio, format: :json)
end
