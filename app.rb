require 'sinatra'
require 'sinatra/assetpack'
require 'json'
require 'nokogiri'
require 'open-uri'

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

  def self.parse_quotes(url)
    response = open(url).read
    doc = Nokogiri::HTML.parse(response)

    quotes = doc.css('.quote-block').map do |quote_block|
      {
        :text => quote_block.css('.text').first.text.strip,
        :citation => quote_block.css('.img img').first.to_s + quote_block.css('.name').first.text.strip,
        :topics => []
      }
    end
  end

  # quotes = JSON.parse(File.read('quotes.json'), :symbolize_names => true)
  quotes = parse_quotes('http://www.screened.com/my-little-pony-friendship-is-magic/17-31970/quotes/')

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
end
