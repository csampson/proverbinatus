require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

include Rack::Test::Methods
def app() @app||= App.new end
