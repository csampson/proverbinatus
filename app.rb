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

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  get '/' do
    erb :index
  end
end
