require 'sinatra'
require 'sinatra/assetpack'
require 'json'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', from: 'assets/css'
    serve '/js', from: 'assets/js'
    serve '/images', from: 'assets/images'

    css :app, ['css/app.css']
    js :app, ['js/app.js']

    js_compression :yui
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  quotes = JSON.parse(File.read('quotes.json'))

  get '/' do
    erb :index
  end

  get '/quotes/?' do
    content_type :json
    quotes.to_json
  end

  get '/quotes/random/?' do
    if params['topic']
      matching_quotes = quotes.select{|quote| quote['topics'].include? params['topic']}

      if matching_quotes.length > 0
        matching_quotes.sample['text']+"\n"
      else
        'No matching quotes found.'+"\n"
      end
    else
      quotes.sample['text']+"\n"
    end
  end
end
