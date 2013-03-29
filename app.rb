require 'sinatra'
require 'sinatra/assetpack'
require 'json'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js', {:from => 'assets/js'}
    serve '/images', {:from => 'assets/images'}

    css :app, ['css/app.css']
    js :app, ['js/app.js']

    js_compression :yui
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  quotes = JSON.parse(File.read('quotes.json'), :symbolize_names => true)

  # trailing newline is zany, but will stay...for now
  def text_response(text)
    text+"\n"
  end

  get '/' do
    erb :index
  end

  get '/quotes/?' do
    content_type :json
    quotes.to_json
  end

  get '/quotes/random/?' do
    text_response quotes.sample[:text]
  end

  get '/quotes/random/:topic/?' do
    matching_quotes = quotes.select{|quote| quote[:topics].include? params[:topic]}

    if matching_quotes.length > 0
      text_response matching_quotes.sample[:text]
    else
      text_response 'No matching quotes found.'
    end
  end
end
