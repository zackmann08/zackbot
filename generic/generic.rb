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
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox Finnish municipality))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise Helper::NoTemplatesFound if templates.empty?
    # raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1
    
    templates.each do |template|
      # template = templates.first
      old_template = template.dup
  
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
      params = Helper.parse_template(template)
      params.default = nil
      # Delete blank values
      params.reject!{|_k,v| v.empty?}
      
      # \{\{\{([a-z\_]*)\|?\}\}\}
      # #{params['$1']}
      
      
      result = "{{Infobox settlement
|name                   = #{params['name']}
|official_name          = #{params['official_name']}
|other_name             = #{params['other_name']}
|native_name            = #{params['native_name']}
|native_name_lang       = #{params['native_name_lang']}
|nickname               = #{params['nickname']}
|settlement_type        = #{params['settlement_type']}
|total_type             = #{params['total_type']}
|motto                  = #{params['motto']}
|image_skyline          = #{params['image_skyline']}
|imagesize              = #{params['imagesize']}
|image_caption          = #{params['image_caption']}
|image_flag             = #{params['image_flag']}
|flag_size              = #{params['flag_size']}
|image_seal             = #{params['image_seal']}
|seal_size              = #{params['seal_size']}
|image_shield           = #{params['image_shield']}
|shield_size            = #{params['shield_size']}
|image_blank_emblem     = #{params['image_blank_emblem']}
|blank_emblem_type      = #{params['blank_emblem_type']}
|blank_emblem_size      = #{params['blank_emblem_size']}
|image_map              = #{params['image_map']}
|mapsize                = #{params['mapsize']|| '150px'}
|map_caption            = #{params['map_caption']}
|pushpin_map            = #{params['pushpin_map']}
|pushpin_label_position = #{params['pushpin_label_position']}
|pushpin_map_caption    = #{params['pushpin_map_caption']}
|pushpin_mapsize        = #{params['pushpin_mapsize']|| '150px'}
|subdivision_type       = Country
|subdivision_name       = {{flag|Finland}}
|subdivision_type1      = [[Regions of Finland|Region]]
|subdivision_name1      = #{params['subdivision_name2']|| params['region']}
|subdivision_type2      = [[Sub-regions of Finland|Sub-region]]
|subdivision_name2      = #{params['subdivision_name3']|| params['subregion']}
|seat_type              = #{params['seat_type']}
|seat                   = #{params['seat']}
|parts_type             = #{params['parts_type']}
|parts_style            = #{params['parts_style']}
|parts                  = #{params['parts']}
|p1                     = #{params['p1']}
|p2                     = #{params['p2']}
|p3                     = #{params['p3']}
|p4                     = #{params['p4']}
|p5                     = #{params['p5']}
|p6                     = #{params['p6']}
|p7                     = #{params['p7']}
|p8                     = #{params['p8']}
|p9                     = #{params['p9']}
|p10                    = #{params['p10']}
|government_footnotes   = #{params['government_footnotes']}
|leader_title           = #{params['leader_title']}
|leader_name            = #{params['leader_name']}
|leader_title1          = #{params['leader_title1']}
|leader_name1           = #{params['leader_name1']}
|leader_title2          = #{params['leader_title2']}
|leader_name2           = #{params['leader_name2']}
|leader_title3          = #{params['leader_title3']}
|leader_name3           = #{params['leader_name3']}
|established_title      = #{params['established_title']}
|established_date       = #{params['established_date']}
|established_title2     = #{params['established_title2']}
|established_date2      = #{params['established_date2']}
|established_title3     = #{params['established_title3']}
|established_date3      = #{params['established_date3']}
|extinct_title          = #{params['extinct_title']}
|extinct_date           = #{params['extinct_date']}
|area_footnotes         = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/total area|{{PAGENAME}}}}*1}}
                            | 
                            | &nbsp;({{subst:Infobox Finnish municipality/total area|sourcedate}}){{subst:Infobox Finnish municipality/total area}}
                          }}
|area_magnitude         = 
|area_total_km2         = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/total area|{{PAGENAME}}}}*1}}
                            | 
                            | {{subst:Infobox Finnish municipality/total area|{{PAGENAME}}}}
                          }}
|area_land_km2          = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/total area|{{PAGENAME}}}}*1}}
                            | 
                            | {{subst:Infobox Finnish municipality/land area|{{PAGENAME}}}}
                          }}
|area_water_km2         = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/total area|{{PAGENAME}}}}*1}}
                            | 
                            | {{subst:Infobox Finnish municipality/waters area|{{PAGENAME}}}}
                          }}
|area_water_percent     = 
|area_urban_km2         = #{params['area_urban_km2']}
|area_metro_km2         = #{params['area_metro_km2']}
|area_rank              = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/total area sequence|{{PAGENAME}} }}*1}}
                          |
                          | {{subst:#ifeq: {{subst:Infobox Finnish municipality/total area sequence|{{PAGENAME}} }} | 1 
                            | [[List of Finnish municipalities by area|Largest]] in Finland
                            | [[List of Finnish municipalities by area|{{subst:ordinal|{{subst:Infobox Finnish municipality/total area sequence|{{PAGENAME}}}}}} largest]] in Finland
                            }}
                          }}
|population_as_of       = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/population count|{{PAGENAME}} }}*1}}
                            | 
                            | {{subst:#time: Y-m-d | {{subst:Infobox Finnish municipality/population count|sourcedate}} }}
                          }}
|population_footnotes   = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/population count|{{PAGENAME}} }}*1}}
                            | 
                            | {{subst:Infobox Finnish municipality/population count}}
                          }}
|population_total       = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/population count|{{PAGENAME}} }}*1}}
                            | 
                            | {{subst:Infobox Finnish municipality/population count|{{PAGENAME}} }}
                          }}
|population_density_km2 = {{subst:Infobox Finnish municipality/population density|{{PAGENAME}}|0|round=2}}
|population_demonym     = #{params['population_demonym']}
|population_metro       = #{params['population_metro']}
|population_blank1_title  = #{params['population_blank1_title']}
|population_blank1        = #{params['population_blank1']}
|population_density_metro_km2 = #{params['population_density_metro_km2']}
|population_urban       = #{params['population_urban']}
|population_density_urban_km2 = #{params['population_density_urban_km2']}
|population_rank        = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/population count sequence|{{PAGENAME}} }}*1}}
                          |
                          | {{subst:#ifeq: {{subst:Infobox Finnish municipality/population count sequence|{{PAGENAME}} }} | 1 
                            | [[List of Finnish municipalities by population|Largest]] in Finland
                            | [[List of Finnish municipalities by population|{{subst:ordinal|{{subst:Infobox Finnish municipality/population count sequence|{{PAGENAME}}}}}} largest]] in Finland
                            }}
                          }}
|population_note        = #{params['population_note']}
|demographics_type1             = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}} }}*1}}
                                  |
                                  | [[Languages of Finland|Population by native language]]
                                  }}
|demographics1_footnotes        = {{subst:Infobox Finnish municipality/native language Finnish}}
|demographics1_title1           = {{subst:#ifeq: {{subst:#expr: {{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}} > {{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}} }} | 1 | [[Finland Swedish|Swedish]]| [[Finnish language|Finnish]]}}
|demographics1_info1            = {{subst:#ifeq: {{subst:#expr: {{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}} > {{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}} }} | 1 | {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}} (official) | {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}} (official) }}
|demographics1_title2           = {{subst:#ifeq: {{subst:#expr: {{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}} > {{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}} }} | 1 | {{subst:#ifeq: {{subst:#expr: (({{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}}/{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}) round 3) >= 0.001 }} | 1 | [[Finnish language|Finnish]] }} | {{subst:#ifeq: {{subst:#expr: (({{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}}/{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}) round 3) >= 0.001 }} | 1 | [[Finland Swedish|Swedish]] }} }}
|demographics1_info2            = {{subst:#ifeq: {{subst:#expr: {{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}} > {{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}} }} | 1 | {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language Finnish|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}} {{subst:#if: #{params['finnish_official']} | (official)}} | {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language Swedish|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}} {{subst:#if: #{params['swedish_official']} | (official)}} }} 
|demographics1_title3           = {{subst:#ifeq: {{subst:#expr: (({{subst:Infobox Finnish municipality/native language Sami|{{PAGENAME}}}}/{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}) round 3) >= 0.001 }} | 1 | [[Sami languages|Sami]] }}
|demographics1_info3            = {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language Sami|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}} {{subst:#if: #{params['sami_official']} | (official)}}
|demographics1_title4           = {{subst:#ifeq: {{subst:#expr: (({{subst:Infobox Finnish municipality/native language other|{{PAGENAME}}}}/{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}) round 3) >= 0.001 }} | 1 | Others }}
|demographics1_info4            = {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/native language other|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/native language total|{{PAGENAME}}}}|1}}}}
|demographics_type2             = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/demography 15-64|{{PAGENAME}} }}*1}}
                                  |
                                  | [[Demographics|Population by age]]
                                  }}
|demographics2_footnotes        = {{subst:Infobox Finnish municipality/demography 0-14}}
|demographics2_title1           = 0 to 14
|demographics2_info1            = {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/demography 0-14|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/demography total|{{PAGENAME}}}}|1}}}}
|demographics2_title2           = 15 to 64
|demographics2_info2            = {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/demography 15-64|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/demography total|{{PAGENAME}}}}|1}}}}
|demographics2_title3           = 65 or older
|demographics2_info3            = {{subst:formatnum: {{subst:percentage|{{subst:Infobox Finnish municipality/demography 65-|{{PAGENAME}}}}|{{subst:Infobox Finnish municipality/demography total|{{PAGENAME}}}}|1}}}}

|blank_name            = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/tax rate|{{PAGENAME}} }}*1}}
                          |
                          | Municipal tax rate{{subst:Infobox Finnish municipality/tax rate}}
                          }}
|blank_info            = {{subst:#iferror: {{subst:#expr: {{subst:Infobox Finnish municipality/tax rate|{{PAGENAME}} }}*1}}
                          |
                          | {{subst:formatnum: {{subst:Infobox Finnish municipality/tax rate|{{PAGENAME}} }}}}%
                          }}
|blank1_name            = {{subst:#if: #{params['urbanisation']} | [[Urbanisation]] }}
|blank1_info            = {{subst:#if: #{params['urbanisation']} | #{params['urbanisation']}% }}
|blank2_name            = {{subst:#if: #{params['unemployment']} | [[Unemployment]] rate }}
|blank2_info            = {{subst:#if: #{params['unemployment']} | #{params['unemployment']}% }}
|blank3_name            = #{params['blank1_name']}
|blank3_info            = #{params['blank1_info']}
|blank4_name            = #{params['blank2_name']}
|blank4_info            = #{params['blank2_info']}
|blank5_name            = #{params['blank3_name']}
|blank5_info            = #{params['blank3_info']}
|blank6_name            = #{params['blank4_name']}
|blank6_info            = #{params['blank4_info']}
|timezone               = [[Eastern European Time|EET]]
|utc_offset             = +2
|timezone_DST           = [[Eastern European Summer Time|EEST]]
|utc_offset_DST         = +3
|coordinates            = #{params['coordinates']}
|elevation_m            = #{params['elevation_m']}
|postal_code_type       = Postal code
|postal_code            = #{params['postal_code']}
|area_code              = #{params['area_code']}
|website                = #{params['website']}
|footnotes              = #{params['footnotes']}
}}"

      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
      
      # This will strip un-used parmeters
      # result.gsub!(/\|.*\=\s*\n/, '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
