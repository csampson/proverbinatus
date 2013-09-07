class ImageTemplate
  @@templates ||= {}

  def self.set_templates templates
    @@templates = templates
  end

  attr_accessor :name, :file, :text_width, :text_height, :font_family,
    :font_size, :column_width

  def initialize template_name
    @name = template_name

    template_hash = @@templates[template_name.to_sym]

    @file = template_hash[:file]
    @text_width = template_hash[:text_width]
    @text_height = template_hash[:text_height]
    @font_family = template_hash[:font_family]
    @font_size = template_hash[:font_size]
    @column_width = template_hash[:column_width]
  end
end
