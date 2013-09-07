class Proverb
  attr_accessor :text, :citation, :topics, :key

  def initialize proverb
    @text = proverb[:text]
    @citation = proverb[:citation]
    @topics = proverb[:topics]
    @key = proverb[:text].hash
  end
end
