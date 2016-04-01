require "sinatra"
require 'newrelic_rpm'
require "sprockets"
require "uglifier"
require "json"

require_relative "./lib/image"

class App < Sinatra::Application
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "assets/css"
  environment.append_path "assets/images"
  environment.append_path "assets/js"

  # compress assets
  environment.js_compressor  = :uglify
  # environment.css_compressor = :scss

  # get assets
  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.environment.call(env)
  end

  quotes = JSON.parse(File.read("./data/quotes.json"), :symbolize_names => true)
  images = JSON.parse(File.read("./data/images.json"), :symbolize_names => true)

  get "/" do
    erb :index
  end

  get "/quotes/?" do
    content_type :json
    quotes.to_json
  end

  get "/quotes/random/?" do
    quotes.sample[:text]
  end

  get "/quotes/random/:topic/?" do
    matching_quotes = quotes.select{|quote| quote[:topics].include? params[:topic]}

    if matching_quotes.length > 0
      matching_quotes.sample[:text]
    else
      "No matching quotes found."
    end
  end

  get "/generate-image/:image/?" do
    content_type "image/png"

    image_config = images[params[:image].to_sym]
    image = Image.new quotes.sample[:text], image_config
    image.draw!

    image.to_blob
  end
end
