require 'rmagick'

class Image
  HEIGHT  = 315
  WIDTH   = 851

  attr_reader :result

  def initialize(text, options)
    @file = options[:file]
    @text = text
    @text_width = options[:text_width]
    @text_height = options[:text_height]
    @font_family = options[:font_family]
    @font_size = options[:font_size]
    @column_width = options[:column_width]
  end

  def draw!
    base = Magick::Image.new HEIGHT, WIDTH
    img = Magick::Image.read(@file).first

    # Add the text
    draw_text_on img, text: word_wrap(@text, @column_width),
                      pointsize: @font_size,
                      gravity: Magick::SouthEastGravity,
                      width: @text_width,
                      height: @text_height,
                      font_family: @font_family

    # Add branding
    draw_text_on img, text: 'www.proverbinatus.com',
                      pointsize: 12,
                      gravity: Magick::SouthEastGravity,
                      width: WIDTH,
                      height: HEIGHT

    img.format = 'png'

    @result = img
  end

  def to_blob
    @result.to_blob
  end

  private
  def draw_text_on(image, width: 0,
                          height: 0,
                          x: 0,
                          y: 0,
                          text: '',
                          fill_color: 'black',
                          font_family: 'arial',
                          pointsize: 10,
                          gravity: CenterGravity)

    draw = Magick::Draw.new
    draw.font_family = font_family
    draw.pointsize = pointsize
    draw.gravity = gravity

    draw.fill = fill_color
    draw.annotate image, width, height, x, y, text
  end

  def word_wrap(text, columns = 80)
    text.split("\n").collect do |line|
      line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end
end
