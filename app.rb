require 'sinatra'
require 'sinatra/assetpack'

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

  def get_quotes

  end

  get '/' do
    erb :index
  end

  get '/get_quote' do
    #random quote
  end
end
