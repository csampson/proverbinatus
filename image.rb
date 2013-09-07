require 'RMagick'
require_relative 'image_template'

class Image
  # Might need to be moved to the template as well.
  HEIGHT  = 315
  WIDTH   = 851

  attr_reader :result

  def initialize(proverb, template_name)
    @template = ImageTemplate.new template_name
    @proverb = proverb
  end

  def draw!
    base = Magick::Image.new HEIGHT, WIDTH
    img = Magick::Image.read(@template.file).first

    # Add the text
    draw_text_on img, text: word_wrap(@proverb.text, @template.column_width),
                      pointsize: @font_size,
                      gravity: Magick::SouthEastGravity,
                      width: @template.text_width,
                      height: @template.text_height,
                      font_family: @template.font_family,
                      pointsize: @template.font_size

    # Add branding
    draw_text_on img, text: 'http://proverbinatus.com/',
                      pointsize: 12,
                      gravity: Magick::SouthEastGravity,
                      width: WIDTH,
                      height: HEIGHT

    img.format = 'png'

    @result = img
  end

  def write!
    Dir.mkdir(self.dir_path) unless File.exists?(self.dir_path)

    @result.write(self.file_path)
  end

  def dir_path
    "temp/#{@template.name}"
  end

  def file_path
    "#{self.dir_path}/#{self.filename}"
  end

  def filename
    "#{@proverb.key}.png"
  end

  def to_blob
    @result.to_blob
  end

  def self.create! proverb, template_name
    image = self.new proverb, template_name
    image.draw!
    image.write!

    image
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

    draw.annotate image, width, height, x, y, text do
      self.fill = fill_color
    end
  end

  def word_wrap(text, columns = 80)
    text.split("\n").collect do |line|
      line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end
end
