require 'sinatra'
require 'sinatra/assetpack'
require 'json'

require_relative 'image'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js', {:from => 'assets/js'}
    serve '/images', {:from => 'assets/images'}

    css :app, ['css/app.css']
    js :app, ['js/app.js']
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  quotes = JSON.parse(File.read('quotes.json'), :symbolize_names => true)
  images = JSON.parse(File.read('images.json'), :symbolize_names => true)

  get '/' do
    erb :index
  end

  get '/quotes/?' do
    content_type :json
    quotes.to_json
  end

  get '/quotes/random/?' do
    quotes.sample[:text]
  end

  get '/quotes/random/:topic/?' do
    matching_quotes = quotes.select{|quote| quote[:topics].include? params[:topic]}

    if matching_quotes.length > 0
      matching_quotes.sample[:text]
    else
      'No matching quotes found.'
    end
  end

  get '/images/:image/?' do
    content_type 'image/png'

    image_config = images[params[:image].to_sym]
    image = Image.new quotes.sample[:text], image_config
    image.draw!

    image.to_blob
  end
end
