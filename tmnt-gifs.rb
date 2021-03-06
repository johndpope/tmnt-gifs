require 'sinatra'
require 'json'

require './gifs'

post '/' do
  # Might want to add a token read from env variable
  #status 500 unless request['token'] == 'your-token-here'

  text, image_url = text_and_image(request['text'])

  content_type :json
  {
    title: 'TMNT Gifs',
    text: text,
    attachments: [
      {
        image_url: image_url,
      }
    ]
  }.to_json
end

get '/' do
  "TMNT Gifs\n\nCowabunga!"
end

private

def text_and_image(reaction)
  gif = TMNT_GIFS
    .select { |h| h[:tags].include?(reaction) }
    .sample

  if gif.nil?
    return fallback_text(reaction), TMNT_GIFS.sample[:url]
  else
    return "\"#{reaction}\". _#{gif[:message]}_", gif[:url]
  end
end

def fallback_text(reaction)
  "I don't have a good reaction for \"#{reaction}\", so I'm returning a random one."
end
