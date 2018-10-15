# encoding: utf-8
require '../helper'
module Album
  class UnresolvedCase < StandardError; end
  class NoTemplatesFound < StandardError; end
  # IDEA: Consider just building a new template and subst: it in so it will be properly formatted? 
  INFOBOX_REGEX = "Album infobox soundtrack|Album [Ii]nfobox|DVD infobox|Infobox [Aa]lbum|Infobox DVD|Infobox EP|Infobox music DVD"
  BREAK = /<\s*[\/]*br\s*[\/]*\s*>/
  PARAMETERS = ""
  WIKIPROJECT = /<!-- See Wikipedia:WikiProject[\s_]Albums -->/
  
  YEAR = /^\(?\d{4}(?:[–-]{1}\d{2,4}|\/\d{2,4})?\)?$/
  YEAR_IN_MUSIC = /^\(?(\[\[\d{4} in music\|\d{4}\]\])\)?$/
  NO_BREAK_STD_CASE = /^(.*)\((\d{4})\)$/
  
  def fix_pipes(text)
    lines = text.split("\n")
    result = ''
    lines.map! do |line|
      line.strip!
      line.chomp!('|')
      line.prepend('|') unless (line.start_with?('|') || line.start_with?('{{') ||line.start_with?('}}'))
      line.gsub!(/\|\}\}/, "\n}}")
      result+= line + "\n"       
    end
    result.strip
  end
  
  def parse_album_year(text)
    return '','' if text.nil? || text.strip.empty?
    text.gsub!(/'''/,'')
    text.gsub!(/''/,'')
    text.gsub!(/<\/?\s*small\s*>/,'')
    text = text.strip.chomp('|')
       
    return text, '' unless text.match?(/\d{4}/)
    
    year = album = ''
    results = text.split(BREAK)
    if results.size!=2
      return text.match(NO_BREAK_STD_CASE)[1].strip.gsub(/(.*)#{BREAK}/, '\1'), text.match(NO_BREAK_STD_CASE)[2] if text.match?(NO_BREAK_STD_CASE)
      raise UnresolvedCase
    end
    results.each do |result|
      result.strip!
      if result.match(YEAR)
        # puts 'YEAR'
        year = result.match(YEAR)[0]
      elsif result.match(YEAR_IN_MUSIC)
        # puts 'YEAR IN MUSIC'
        year = result.match(YEAR_IN_MUSIC)[0]
      else
        unless album.empty?
          year = result.match(/\d{4}/)[0]
          next
        end
        album = result
      end
    end
    return album.gsub(/(.*)#{BREAK}/, '\1'), year.tr('()', '')
  end
  
  LAST_ALBUM = /Last album\s*=(.*)/
  NEXT_ALBUM = /Next album\s*=(.*)/
  
  def parse_album(page)
    templates = page.scan(/(?=\{\{(?:#{INFOBOX_REGEX.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
        
    templates.each do |template|
      old_text = template.dup
      
      template.gsub!(/\|\s*#{WIKIPROJECT}?\s*\n*\|/, "\n|")

      if template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\|/) && !template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\n\s*\|/)
        template = fix_pipes(template)
      end

      template.each_line do |line|
        template.gsub!(line, "#{line.chomp("}}")}\n}}") if (!line.start_with?('}}') && line.end_with?('}}'))
      end

      last_data = parse_album_year(template.match(LAST_ALBUM)[1]) if template.match?(LAST_ALBUM)
      next_data = parse_album_year(template.match(NEXT_ALBUM)[1]) if template.match?(NEXT_ALBUM)
      
      template.gsub!(/<!--.*-->/,        '')
      template.gsub!(/#{INFOBOX_REGEX}/, 'subst:Infobox Album')
      template.gsub!(/\{\{\s*Extra chronology/, '{{subst:Extra chronology')
      
      template.gsub!(/[Ii]talic title(\s*)=/, 'italic_title\1=')
      template.gsub!(/Name(\s*)=/,       'name\1=')
      template.gsub!(/Type(\s*)=/,       'type\1=')
      template.gsub!(/image(\s*)=/,      'cover\1=')
      template.gsub!(/Cover(\s*)=/,      'cover\1=')
      template.gsub!(/Border(\s*)=/,     'border\1=')
      template.gsub!(/Alt(\s*)=/,        'alt\1=')
      template.gsub!(/Caption(\s*)=/,    'caption\1=')
      template.gsub!(/Longtype(\s*)=/,   'longtype\1=')
      template.gsub!(/Artist(\s*)=/,     'artist\1=')
      template.gsub!(/Released(\s*)=/,   'released\1=')
      template.gsub!(/Recorded(\s*)=/,   'recorded\1=')
      template.gsub!(/Venue(\s*)=/,      'venue\1=')
      template.gsub!(/Studio(\s*)=/,     'studio\1=')
      template.gsub!(/Genre(\s*)=/,      'genre\1=')
      template.gsub!(/Length(\s*)=/,     'length\1=')
      template.gsub!(/Language(\s*)=/,   'language\1=')
      template.gsub!(/Label(\s*)=/,      'label\1=')
      template.gsub!(/Director(\s*)=/,   'director\1=')
      template.gsub!(/Producer(\s*)=/,   'producer\1=')
      template.gsub!(/Compiler(\s*)=/,   'compiler\1=')
      template.gsub!(/Chronology(\s*)=/, 'chronology\1=')
      template.gsub!(/Misc(\s*)=/,       'misc\1=')
      template.gsub!(LAST_ALBUM,          '')
      template.gsub!(NEXT_ALBUM,          '')
      template.gsub!(/\s*\|\s*\n/,        "\n")
      template.gsub!(/\{\{flat\s?list\s*\n/i, "{{flatlist|\n")
      template.gsub!(/\{\{plain\s?list\s*\n/i, "{{plainlist|\n")
      
      template.insert(-3, "| prev_title=#{last_data[0]}\n| prev_year=#{last_data[1]}\n") if last_data
      template.insert(-3, "| next_title=#{next_data[0]}\n| next_year=#{next_data[1]}\n") if next_data
      
      template.each_line do |line|
        template.gsub(line, "|#{line}") unless (line.start_with?('|') || line.start_with?('{{') || line.start_with?('}}'))
        template.gsub(line, line.slice(-1)) if (line.end_with?("|\n") && !line.include?('{{'))
      end
      template.gsub!(/\n\n/, "\n")
      page.gsub!(old_text, template)
    end
        
    page    
  end
end