# encoding: utf-8
class Page
  attr_accessor :raw_text

  class NoTemplatesFound < StandardError
    def initialize
      super("page class did not find any templates matching regex")
    end
  end
  
  def initialize(text)
    @raw_text = text
  end
  
  def get_templates(template)
    results = @raw_text.scan(/(?=\{\{(?:#{template.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if results.empty?
    results
  end  
end