require File.expand_path '../spec_helper.rb', __FILE__

describe 'App' do
  quotes = JSON.parse(File.read(File.dirname(__FILE__) + '/../quotes.json'), :symbolize_names => true)

  it 'can load front-end' do
    get '/'
    last_response.should be_ok
  end

  it 'can return all quotes' do
    get '/quotes'
    last_response.should be_ok
    JSON.parse(last_response.body).should_not be_empty
  end

  it 'can return a random quote' do
    get '/quotes/random'
    last_response.should be_ok
    last_response.body.should_not be_empty
  end

  it 'should have quotes with citations' do
    quotes.any?{|q| !q[:citation] }.should == false
  end

  it 'should have quotes with text' do
    quotes.any?{|q| !q[:text] }.should == false
  end
end
