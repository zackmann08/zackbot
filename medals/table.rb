# encoding: utf-8
module Table
  class NoCountries < StandardError; end
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class DuplicateIocs < StandardError
    def initialize(duplicates)
      super("Duplicate IOCs '#{duplicates}'")
    end
  end
  
  def self.log_countries(countries)
    countries.each do |c|
      puts c.inspect
    end
  end
  
  def self.parse_table(string)
    caption = ''
    caption_results = string.match(/\|\s*caption\s*\=([^\|\}]*)/)
    caption = caption_results[1] if caption_results
    team = ''
    team_results = string.match(/\|\s*team\s*\=([^\|\}]*)/)
    team = team_results[1] if team_results
    
    raise UnresolvedCase.new('NTS') if string.match?(/\{\{nts\|/)
    raise UnresolvedCase.new('REF') if string.match?(/\{\{ref\|/)
    raise UnresolvedCase.new('break') if string.match?(/<br\s*>/i)
    raise UnresolvedCase.new('No spacing between pipes') if string.match?(/\|\|\|/)
    # raise UnresolvedCase.new('ITALICS') if string.match?(/\'\'\{\{/)
    string.gsub!(/\–/, '-')
    string.gsub!(/\|-\s*bgcolor=lightgray\s*\n\|(?:\s*\|\|)+/, '')
    string.gsub!(/\{\{nowrap\|(.*)\}\}/, '\1')
    string.gsub!(/USSR/, 'Soviet Union')
    string.gsub!(/\{\{\s*Soviet Union\s*\}\}/, '{{flag|Soviet Union}}')
    string.gsub!(/\{\{nts\|(\d*)\}\}/, '\1')
    string.gsub!(/(background.*\|\s*)(?=\n)/, '\1 0')
    string.gsub!(/\s*style="background[\-color]*\s*:\s*#[D-F][A-Z0-9]{5}[;"]*\s*\|*/i, '')
    string.gsub!(/(?<=\|\|)[\-\s]*(?=\|\|)/, '0')
    string.gsub!(/\|\|\|/, '||')
    string.gsub!(/\{\{([A-Z]{3}\|\d{4})\}\}/, '{{flag|\1}}')
    # string.gsub!(/\[\[.*\]\]/, '')
    string.gsub!(/<center>(.*)<\/center>/, '\1')
    string.gsub!(/<sup>.*<\/sup>/, '')
    string.gsub!(/<span>.*<\/span>/, '')
    string.gsub!(/<small>.*<\/small>/, '')
    string.gsub!(/\|align=center\|/, '|')
    string.gsub!("GBR2", "GBR")
    string.gsub!("UK-GBR", "GBR")
    string.gsub!(/\{\{sort[^\}]*\}\}/, "-")
    string.gsub!(/\}\}[\s\w]*\|/, '}} |')
    string.gsub!(/'''/, '')
    string.gsub!(/<small>\(host nation\)<\/small>/i, '')
    string.gsub!(/\}\}\s*\**/, '}}')
    string.gsub!(/\|\s+\n/, '| 0')
    string.gsub!(/\|\s+\-\n/, '| 0')

    rows = string.split('|-')

    countries = rows.map{|row| Country.new(row) }
    countries.select!{|c| c.valid}
    result = ''

    
    # Figure out whether all countries use the same flag template or not
    templates = countries.map{|c| c.template}
    events = countries.map{|c| c.event}

    template = ''
    template = templates[0] if templates.all? {|t| t == templates[0]}
    template = '' if template.nil?
    event = ''
    event = events[0] if events.all? {|t| t == events[0]}

    # log_countries(countries)
    
    raise NoCountries if countries.empty?

    if countries.first.ioc == 'AAA'
      ('A'..'Z').each_with_index do |letter, index|
        break if countries[index].nil?
        countries[index].ioc = letter * 3
      end
    end
      
    countries.each do |country|
      temp = country.to_template(template, event)
      result += temp unless temp.strip.empty?
    end
    
    iocs = countries.map{|c| c.ioc}
    duplicates = iocs.detect{ |ioc| iocs.count(ioc) > 1 }
    raise DuplicateIocs.new(duplicates) unless (duplicates.nil? || duplicates.empty?)
        
    host = ''
    host_results = result.match(/host\_([A-Z]{3})/)
    host = host_results[1] if host_results

    # Never set the template as flag or flagicon
    template = '' if (template.match?(/flagicon/i) || template.downcase.strip == 'flag' || template.downcase.strip == 'flagcountry')
    if string.match?(/<[\/]*includeonly>|<[\/]*onlyinclude>/)
      result = " | remaining_link = [[|Remaining]]
 | show_limit     = <includeonly>10</includeonly>

" + result
    end
   result = "{{Medals table
 | caption        = #{caption}
 | host           = #{host}
 | flag_template  = #{template}
 | event          = #{event}
 | team           = #{team}
" + result
    
    result.gsub!(/\{\{[Ff]lag\|/, '{{flagteam|')
    
    result += "}}"
    result
  end  
end


