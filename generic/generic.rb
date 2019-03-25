# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end

  def autolink(value)
    return '' if value.nil? || value.empty?
    return value if (value.include?('[[') || value.include?('{{'))
    "{{subst:#ifexist:#{value}|[[#{value}]]|#{value}}}"
  end
  
  def parse_map(params)
    if params['coordinates']
      if params['province']
        return "South Africa #{params['province']}#South Africa"
      else
        'South Africa'
      end
    end
  end
    
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox South African town|Infobox South African subplace|Infobox South African subplace 2011|Infobox South African town 2011))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise Helper::NoTemplatesFound if templates.empty?
    # raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1
        
    templates.each do |template|
      old_template = template.dup
  
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
      params = Helper.parse_template(template)
      params.default = nil
      # Delete blank values
      params.reject!{|_k,v| v.empty?}
      
      # params.each do |k,v|
      #   puts "#{k}: #{v}"
      # end
      # 
      # puts "####################"
      # 
      # puts params['government_footnotes']
      
      # \{\{\{([a-z\_]*)\|?\}\}\}
      # #{params['$1']}

      # raise Helper::UnresolvedCase.new('Has "image"') if (params['image'] && params['image3'])
      # raise Helper::UnresolvedCase.new('Has "image2"') if (params['image2'] && params['image3'])
      # raise Helper::UnresolvedCase.new('bad area') unless (!params['area'].nil? && params['area'].match?(/^[\d\,\s]*$/))
      # raise Helper::UnresolvedCase.new('bad areakm') unless (!params['areakm'].nil? && params['areakm'].match?(/^[\d\,\s]*$/))
      
      result = "{{Infobox settlement
| name                    = #{params['name']}
| official_name           = #{params['official_name']}
| other_name              = #{params['other_name']}
| native_name             = #{params['native_name']}
| native_name_lang        = 
| image_skyline           = #{params['image_skyline']}
| image_alt               = #{params['image_alt']}
| image_caption           = #{params['image_caption']}
| imagesize               = 
| image_flag              = #{params['image_flag']}
| flag_alt                =
| image_seal              = #{params['image_seal']}
| seal_alt                =
| image_shield            = #{params['image_shield']}
| shield_alt              =
| nickname                = #{params['nickname']}
| nicknames               = #{params['nicknames']}
| motto                   = #{params['motto']}
| mottoes                 = #{params['mottoes']}
| image_map               = #{params['image_map']}
| map_alt                 =
| map_caption             = #{params['map_caption']}
| pushpin_map             = #{parse_map(params)}
| coordinates             = #{params['coordinates']}
| subdivision_type        = Country
| subdivision_name        = [[South Africa]]
| subdivision_type1       = Province
| subdivision_name1       = {{subst:#if: #{params['province']} | [[{{subst:#switch: #{params['province']} | Free State = Free State (province){{subst:!}}Free State | North West = North West (South African province){{subst:!}}North West |#default = #{params['province']} }}]] | }}
| subdivision_type2       = District
| subdivision_name2       = #{"[[#{params['district']} District Municipality|#{params['district']}]]" if params['district']}
| subdivision_type3       = Municipality
| subdivision_name3       = {{subst:#if: #{params['municipality']} | [[{{subst:#switch: #{params['municipality']} | Buffalo City | City of Cape Town | Ekurhuleni | eThekwini | City of Johannesburg | Mangaung | Nelson Mandela Bay | City of Tshwane = #{params['municipality']} Metropolitan Municipality{{subst:!}}#{params['municipality']} | Emalahleni = Emalahleni Local Municipality, #{params['province']}{{subst:!}}Emalahleni | Naledi = Naledi Local Municipality, #{params['province']}{{subst:!}}Naledi | #default = #{params['municipality']} Local Municipality{{subst:!}}#{params['municipality']} }}]] | }}
| subdivision_type4       = Main Place
| subdivision_name4       = #{"[[#{params['mainplace']}]]" if params['mainplace']}
| established_title       = #{params['established_title']||'Established'}
| established_date        = #{params['established_date']}
| established_title1      = #{params['established_title1']}
| established_date1       = #{params['established_date1']}
| established_title2      = #{params['established_title2']}
| established_date2       = #{params['established_date2']}
| named_for               = #{params['named_for']}
| government_footnotes    = #{params['government_footnotes'].gsub!(/\n*/, '') if params['government_footnotes']}
| government_type         = #{params['government_type']}
| leader_party            = #{params['leader_party']}
| leader_title            = #{params['leader_title']}
| leader_name             = #{params['leader_name']}
| leader_title1           = #{params['leader_title1']}
| leader_name1            = #{params['leader_name1']}
| leader_title2           = #{params['leader_title2']}
| leader_name2            = #{params['leader_name2']}
| area_footnotes          = {{subst:#if: #{params['censuscode']} | {{subst:#tag:ref |{{cite web |url=http://census2011.adrianfrith.com/place/#{params['censuscode']} |title = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 9 | Sub | Main }} Place #{params['name']||'{{subst:PAGENAME}}'} |work=Census 2011}} |name=census2011}} | #{params['area_footnotes']} }}
| area_total_km2          = {{subst:#if: #{params['censuscode']} | {{subst:Metadata South Africa/{{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 9 | s | m }}p2011/area{{subst:Str left|#{params['censuscode']} }}|#{params['censuscode']} }} | #{params['area_total_km2']} }}
| area_urban_km2          = #{params['area_urban_km2']}
| area_metro_km2          = #{params['area_metro_km2']}
| area_urban_footnotes    = #{params['area_urban_footnotes']}
| area_metro_footnotes    = #{params['area_metro_footnotes']}
| elevation_m             = #{params['elevation_m']}
| elevation_max_m         = #{params['elevation_max_m']}
| elevation_min_m         = #{params['elevation_min_m']}
| population_footnotes    = #{'<ref name="census2011" />' if params['censuscode']}#{params['population_footnotes']}
| population_est          = #{params['population_est']}
| pop_est_as_of           = #{params['pop_est_as_of']}
| population_total        = {{subst:#if: #{params['censuscode']} | {{subst:Metadata South Africa/{{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 9 |s|m}}p2011/pop{{subst:Str left|#{params['censuscode']} }}|#{params['censuscode']} }} | #{params['population_total']} }}
| population_as_of        = #{params['censuscode'] ? '2011' : params['population_as_of']}
| population_density_km2  = auto
| population_metro        = #{params['population_metro']}
| population_urban        = #{params['population_urban']}
| population_density_metro_km2 = #{'auto' if params['population_metro']}
| population_density_urban_km2 = #{'auto' if params['population_urban']}
| population_metro_footnotes = #{params['population_metro_footnotes']}
| population_urban_footnotes = #{params['population_urban_footnotes']}
| population_demonym      = #{params['population_demonym']}
| population_demonyms     = #{params['population_demonyms']}
| population_note         = #{params['population_note']}
<!-- demographics (section 1) -->
| demographics_type1      = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | Racial makeup (2011) | {{subst:#if: #{params['percent_black']} #{params['percent_coloured']} #{params['percent_asian']} #{params['percent_white']} | Racial makeup ({{subst:#if: #{params['censuscode']} | 2011 | #{params['population_as_of']} }}) }} }}
| demographics1_footnotes = #{'<ref name="census2011" />' if params['censuscode']}#{params['demographics1_footnotes']}
| demographics1_title1    = [[Bantu peoples of South Africa|Black African]]
| demographics1_info1     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 1 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 1 }}% }} | #{params['percent_black']} }}
| demographics1_title2    = [[Coloureds|Coloured]]
| demographics1_info2     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 2 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 2 }}% }} | #{params['percent_coloured']} }}
| demographics1_title3    = [[Indian South African|Indian]]/[[Asian South African|Asian]]
| demographics1_info3     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 3 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 3 }}% }} | #{params['percent_asian']} }}
| demographics1_title4    = [[White South African|White]]
| demographics1_info4     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 4 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 4 }}% }} | #{params['percent_white']} }}
| demographics1_title5    = Other
| demographics1_info5     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 5 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/race{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 5 }}% }} | #{params['percent_other']} }}
<!-- demographics (section 2) -->
| demographics_type2      = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | [[First language]]s (2011) | {{subst:#if: #{params['demographics2_info1']} | [[First language]]s ({{subst:#if: #{params['censuscode']} | 2011 | #{params['population_as_of']} }}) }} }}
| demographics2_footnotes = {{subst:#if: #{params['censuscode']} | <ref name=\"census2011\" /> | #{params['demographics2_footnotes']} }}
| demographics2_title1    = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:Infobox South African town/langname| #{params['censuscode']} | 1 }} | #{params['demographics2_title1']} }}
| demographics2_info1     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 2 }}% | #{params['demographics2_info1']} }}
| demographics2_title2    = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:Infobox South African town/langname| #{params['censuscode']} | 3 }} | #{params['demographics2_title2']} }}
| demographics2_info2     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 4 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 4 }}% }} | #{params['demographics2_info2']} }}
| demographics2_title3    = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:Infobox South African town/langname| #{params['censuscode']} | 5 }} | #{params['demographics2_title3']} }}
| demographics2_info3     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 6 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 6 }}% }} | #{params['demographics2_info3']} }}
| demographics2_title4    = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:Infobox South African town/langname| #{params['censuscode']} | 7 }} | #{params['demographics2_title4']} }}
| demographics2_info4     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 8 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 8 }}% }} | #{params['demographics2_info4']} }}
| demographics2_title5    = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | Other | #{params['demographics2_title5']} }}
| demographics2_info5     = {{subst:#ifeq: {{subst:str len|#{params['censuscode']} }} | 6 | {{subst:#if: {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 9 }} | {{subst:#titleparts: {{subst:Metadata South Africa/mp2011/lang{{subst:str left|#{params['censuscode']} }}|#{params['censuscode']} }} | 1 | 9 }}% }} | #{params['demographics2_info5']} }}
| blank_name_sec1         = #{params['blank_name_sec1']}
| blank_info_sec1         = #{params['blank_info_sec1']}
| blank1_name_sec1        = #{params['blank1_name_sec1']}
| blank1_info_sec1        = #{params['blank1_info_sec1']}
| blank2_name_sec1        = #{params['blank2_name_sec1']}
| blank2_info_sec1        = #{params['blank2_info_sec1']}
<!-- blank fields (section 2) -->
| blank_name_sec2         = #{params['blank_name_sec2']}
| blank_info_sec2         = #{params['blank_info_sec2']}
| blank1_name_sec2        = #{params['blank1_name_sec2']}
| blank1_info_sec2        = #{params['blank1_info_sec2']}
| blank2_name_sec2        = #{params['blank2_name_sec2']}
| blank2_info_sec2        = #{params['blank2_info_sec2']}
<!-- Other information -->
| timezone1               = [[South African Standard Time|SAST]]
| utc_offset1             = +2
| postal_code_type        = [[List of postal codes in South Africa|Postal code]] (street)
| postal_code             = {{subst:#if: #{params['postal_code']} | #{params['postal_code']} | {{subst:#if: {{subst:#titleparts: {{subst:Metadata ZA post|#{params['name']} }} | 1 | 2 }} | {{subst:#titleparts: {{subst:Metadata ZA post|#{params['name']} }} | 1 | 2 }} }} }}
| postal2_code_type       = [[Post-office box|PO box]]
| postal2_code            = {{subst:#if: #{params['postal2_code']} | #{params['postal2_code']} | {{subst:#if: {{subst:#titleparts: {{subst:Metadata ZA post|#{params['name']} }} | 1 | 1 }} | {{subst:#titleparts: {{subst:Metadata ZA post|#{params['name']} }} | 1 | 1 }} }} }}
| area_code_type          = [[Telephone numbers in South Africa|Area code]]
| area_code               = #{params['area_code']}
| website                 = #{params['website']}
| footnotes               = #{params['footnotes']}
}}"

    
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
      
      # This will strip un-used parmeters
      result.gsub!(/\|.*\=\s*\n/, '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
