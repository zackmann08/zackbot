# encoding: utf-8
require '../helper'

# TODO: take care of Extra chronology
# Find {{extra chronology|....}} and remove it from the template
# procceed as usual
# parse the extra chronology text

module Album
  class UnresolvedCase < StandardError; end
  class NoTemplatesFound < StandardError; end
  # IDEA: Consider just building a new template and subst: it in so it will be properly formatted? 
  # INFOBOX_REGEX = "Album infobox soundtrack|Album [Ii]nfobox|DVD infobox|Infobox [Aa]lbum|Infobox DVD|Infobox EP|Infobox music DVD"
  # INFOBOX_REGEX = "Extra chronology"
  # INFOBOX_REGEX = "Infobox [Ss]ingle|Infobox Singles|Info box single|Single [Ii]nfobox"
  INFOBOX_REGEX = "Infobox [Ss]ong|Infobox [Ss]tandard|Song infobox|Infobox Korean song|Infobox [Ss]ingle|Infobox Singles|Info box single|Single [Ii]nfobox"
  BREAK = /<\s*[\/]*br\s*[\/]*\s*>/
  PARAMETERS = ""
  WIKIPROJECT = /<!-- See\s*Wikipedia:WikiProject[\s_]Albums -->/
  
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
    text.gsub!(/'''''/,'')
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
    album.gsub!(/(.*)#{BREAK}/, '\1')
    return album.strip.gsub(/^"(.*)"$/, '\1'), year.tr('()', '')
  end
  
  EXTRA_LAST_ALBUM = /(?:Last album|last_album|Last single|last_single)\s*=(.*(?:<ref>[\w\W]*?<\/ref>.*)|.*)/
  EXTRA_THIS_ALBUM = /(?:This album|this_album|This single|this_single)\s*=(.*(?:<ref>[\w\W]*?<\/ref>.*)|.*)/
  EXTRA_NEXT_ALBUM = /(?:Next album|next_album|Next single|next_single)\s*=(.*(?:<ref>[\w\W]*?<\/ref>.*)|.*)/
  def parse_extra_chrono(text)
    text.strip!
    text.gsub!(/'''''/,'')
    text.gsub!(/'''/,'')
    text.gsub!(/''/,'')
    
    text.gsub!(/<\/?\s*small\s*>/,'')
    text.gsub!(/\}\}$/, "\n}}")
    text.gsub!(/\{\{\s*Extra chronology/i, '{{subst:Extra chronology')
    last_data = parse_album_year(text.match(EXTRA_LAST_ALBUM)[1]) if text.match?(EXTRA_LAST_ALBUM)
    this_data = parse_album_year(text.match(EXTRA_THIS_ALBUM)[1]) if text.match?(EXTRA_THIS_ALBUM)
    next_data = parse_album_year(text.match(EXTRA_NEXT_ALBUM)[1]) if text.match?(EXTRA_NEXT_ALBUM)

    text.gsub!(EXTRA_LAST_ALBUM, '')
    text.gsub!(EXTRA_THIS_ALBUM, '')
    text.gsub!(EXTRA_NEXT_ALBUM, '')
    text.insert(-3, "| prev_title=#{last_data[0]}\n| prev_year=#{last_data[1]}\n") if last_data
    text.insert(-3, "| title=#{this_data[0]}\n| year=#{this_data[1]}\n") if this_data
    text.insert(-3, "| next_title=#{next_data[0]}\n| next_year=#{next_data[1]}\n") if next_data

    text.gsub!(/\n\n/, "\n")
    # NEEDED TWICE!
    text.gsub!(/\n\s*\|\s*\n/, "\n")
    text.gsub!(/\n\s*\|\s*\n/, "\n")
    text.strip
  end
  
  LAST_ALBUM = /Last single\s*=(.*(?:<ref>[\w\W]*?<\/ref>.*)|.*)/
  NEXT_ALBUM = /Next single\s*=(.*(?:<ref>[\w\W]*?<\/ref>.*)|.*)/
  def parse_album(page)
    templates = page.scan(/(?=\{\{\s*(?:#{INFOBOX_REGEX.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
        
    templates.each do |template|
      old_text = template.dup
      template.gsub!(/<!--[\w\W]*?-->/,'')
      
      # Find the extra chrology template(s) and replace with a place hold to be fixed later. 
      extra_chrono = template.scan(/(?=\{\{\s*Extra chronology)(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
      extra_chrono.each do |ex|
        template.gsub!(ex, '!EXTRA!')
      end
      extra_chrono.map! do |ex|
        parse_extra_chrono(ex)
      end
      template.gsub!(/\|\s*#{WIKIPROJECT}?\s*\n*\|/, "\n|")

      if template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\|/i) && !template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\n\s*\|/i)
        template = fix_pipes(template)
      end

      template.each_line do |line|
        template.gsub!(line, "#{line.chomp("}}")}\n}}") if (!line.start_with?('}}') && line.end_with?('}}'))
      end

      last_data = parse_album_year(template.match(LAST_ALBUM)[1]) if template.match?(LAST_ALBUM)
      next_data = parse_album_year(template.match(NEXT_ALBUM)[1]) if template.match?(NEXT_ALBUM)
      
      template.gsub!(/<!--.*-->/,        '')
      # template.gsub!(/#{INFOBOX_REGEX}/i, 'subst:Infobox Album')
      # template.gsub!(/#{INFOBOX_REGEX}/i, 'subst:Infobox single')
      template.gsub!(/#{INFOBOX_REGEX}/i, 'subst:Infobox song | type = single')
      # template.gsub!(/{{\s*singles/i, '{{subst:singles')
      # template.gsub!(/{{\s*Extra album cover/i, '{{subst:Extra album cover')
      # template.gsub!(/{{\s*Extra track listing/i, '{{subst:Extra track listing')
      # template.gsub!(/{{\s*Extra tracklisting/i, '{{subst:Extra track listing')
      # template.gsub!(/\{\{\s*Extra chronology/, '{{subst:Extra chronology')
      
      # template.gsub!(/[Ii]talic title(\s*)=/, 'italic_title\1=')
      # template.gsub!(/Name(\s*)=/,       'name\1=')
      # template.gsub!(/Type(\s*)=/,       'type\1=')
      # template.gsub!(/image(\s*)=/,      'cover\1=')
      # template.gsub!(/Cover(\s*)=/,      'cover\1=')
      # template.gsub!(/Border(\s*)=/,     'border\1=')
      # template.gsub!(/Alt(\s*)=/,        'alt\1=')
      # template.gsub!(/Caption(\s*)=/,    'caption\1=')
      # template.gsub!(/Longtype(\s*)=/,   'longtype\1=')
      # template.gsub!(/Artist(\s*)=/,     'artist\1=')
      # template.gsub!(/Released(\s*)=/,   'released\1=')
      # template.gsub!(/Recorded(\s*)=/,   'recorded\1=')
      # template.gsub!(/Venue(\s*)=/,      'venue\1=')
      # template.gsub!(/Studio(\s*)=/,     'studio\1=')
      # template.gsub!(/Genre(\s*)=/,      'genre\1=')
      # template.gsub!(/Length(\s*)=/,     'length\1=')
      # template.gsub!(/Language(\s*)=/,   'language\1=')
      # template.gsub!(/Label(\s*)=/,      'label\1=')
      # template.gsub!(/Director(\s*)=/,   'director\1=')
      # template.gsub!(/Producer(\s*)=/,   'producer\1=')
      # template.gsub!(/Compiler(\s*)=/,   'compiler\1=')
      # template.gsub!(/Chronology(\s*)=/, 'chronology\1=')
      # template.gsub!(/Misc(\s*)=/,       'misc\1=')
      template.gsub!(LAST_ALBUM,          '')
      template.gsub!(NEXT_ALBUM,          '')
      # template.gsub!(/\s*\|\s*\n/,        "\n")
      # template.gsub!(/\{\{flat\s?list\s*\n/i, "{{flatlist|\n")
      # template.gsub!(/\{\{plain\s?list\s*\n/i, "{{plainlist|\n")
      # 
      template.insert(-3, "| prev_title=#{last_data[0]}\n| prev_year=#{last_data[1]}\n") if last_data
      template.insert(-3, "| next_title=#{next_data[0]}\n| next_year=#{next_data[1]}\n") if next_data
      
      new_temp = template.each_line.map do |line|
        line = "|#{line}" unless (line.match?(/^\s*\|/) || 
            line.match?(/^\s*\}\}/) || 
            line.match?(/!EXTRA!/) || 
            line.start_with?('*') || 
            line.start_with?('{{') || 
            line.start_with?('}}') || 
            (!line.include?('=') && line.match?(/\w+/)) #it doesn't contain a parameter and isn't a blank line.
        )
        line.slice!(-1) if (line.end_with?("|\n") && !line.include?('{{'))
        line
      end
      template = new_temp.join("\n")
      template.gsub!(/\n\n/, "\n")
      template.gsub!(/\n\s*\|\s*\n/, "\n")
      extra_chrono.each do |extra|
        template.sub!(/!EXTRA!/, extra)
      end
      template.gsub!(/\n\s*\|\s*\n/, "\n")
      raise 'HAS LEFTOVER TEXT' if template.match?(/!EXTRA!/)
      page.gsub!(old_text, template)
    end
        
    page 
  end
  
  def parse_song(page)
    templates = page.scan(/(?=\{\{\s*(?:#{INFOBOX_REGEX.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
        
    templates.each do |template|
      old_text = template.dup
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # 
      # if template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\|/i) && !template.match?(/\{\{\s*(?:#{INFOBOX_REGEX})\s*\n\s*\|/i)
      #   template = fix_pipes(template)
      # end
      template.gsub!(/<!--.*-->/,        '')
      template.gsub!(/#{INFOBOX_REGEX}/i, 'subst:Infobox song')
      page.gsub!(old_text, template)
    end
        
    page    
  end
end