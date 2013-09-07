require 'sinatra'
require 'sinatra/assetpack'
require 'json'

require_relative 'image'
require_relative 'proverb'
require_relative 'image_template'

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

  ImageTemplate.set_templates JSON.parse(File.read('images.json'), :symbolize_names => true)
  Dir.mkdir('temp') unless File.exists?('temp')

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


  get '/image/:image_template/random?' do |image_template|
    proverb = Proverb.new quotes.sample
    image = Image.create! proverb, image_template

    redirect "image/#{image_template}/#{image.filename}"
  end

  get '/image/:image_template/:filename' do |template, filename|
    send_file "temp/#{template}/#{filename}"
  end
end
