require 'normalize_country'
# 'FOO' => ['BAR'],
IOC_CODES = {'Menorca' => ['MEN'], 'DR Congo' => ['COD'], 'Republic of the Congo' => ['CGO'], 'Gotland' => ['GOT'], 'Bosnia and Herzegovina' => ['BIH'], 'Bosnia' => ['BIH'],'Quebec' => ['QBC'], 'Mayotte' => ['MYT'], 'Réunion' => ['REU'], 'Nevis' => ['NEV'], 'Hawaii' => ['HAW'], 'Taiwan' => ['TWN'],'Micronesia' => ['FSM'], 'Northern Marianas' => ['MNP'], 'United States Virgin Islands' => ['VIR'], 'U.S. Virgin Islands' => ['VIR'], 'Dutch Guiana' => ['NGY'], 'United Kingdom' => ['UKB'], 'FR Yugoslavia' => ['FRY'], 'SFR Yugoslavia' => ['SFR'], 'Guinea Bissau'=> ['GNB'], 'Greenland'=> ['GRL'], 'French Guiana' => ['GUF'], "Martinique" => ["MTQ"], "Åland"=> ["ALA"], "Côte d'Ivoire" => ["CIV"], "Guadeloupe" => ["GLP"], "Aden"=>["ADN"], "Afghanistan"=>["AFG"], "Netherlands Antilles"=>["AHO"], "Anguilla"=>["AIA"], "Albania"=>["ALB"], "Algeria"=>["ALG"], "Authorised Neutral Athletes"=>["ANA"], "Andorra"=>["AND"], "Angola"=>["ANG"], "Antigua and Barbuda"=>["ATG"], "Australasia"=>["ANZ"], "Isle of Wight"=>["IOW"], "Independent Olympic Athletes"=>["IOA"], "Argentina"=>["ARG"], "Armenia"=>["ARM"], "Athlete Refugee Team"=>["ART"], "Aruba"=>["ARU"], "American Samoa"=>["ASA"], "Shetland Islands"=>["SHE"],  "Australia"=>["AUS"], "Austria"=>["AUT"], "Azerbaijan"=>["AZE"], "Bahamas"=>["BAH"], "The Bahamas"=>["BAH"], "Bangladesh"=>["BAN"], "Barbados"=>["BAR"], "Burundi"=>["BDI"], "Belgium"=>["BEL"], "Benin"=>["BEN"], "Bermuda"=>["BER"], "British Guiana"=>["BGU"], "Bahrain"=>["BRN"], "Bhutan"=>["BHU"], "Burma"=>["BIR"], "Belize"=>["BIZ"], "Belarus"=>["BLR"], "British North Borneo"=>["BNB"], "Bohemia"=>["BOH"], "Bolivia"=>["BOL"], "Botswana"=>["BOT"], "Brazil"=>["BRA"], "Brunei"=>["BRU"], "Bulgaria"=>["BUL"], "Burkina Faso"=>["BUR"], "British West Indies"=>["BWI"], "Central African Republic"=>["CAF"], "Cambodia"=>["CAM"], "Canada"=>["CAN"], "Cayman Islands"=>["CAY"], "Ceylon"=>["CEY"], "Congo"=>["CGO"], "Chad"=>["CHA"], "Chile"=>["CHI"], "China"=>["CHN"], "Ivory Coast"=>["CIV"], "Cameroon"=>["CMR"], "Democratic Republic of the Congo"=>["COD"], "Cook Islands"=>["COK"], "Colombia"=>["COL"], "Comoros"=>["COM"], "Korea"=>["COR"], "Cape Verde"=>["CPV"], "Costa Rica"=>["CRC"], "Croatia"=>["CRO"], "Cuba"=>["CUB"], "Cura\u00E7ao"=>["CUW"], "Cyprus"=>["CYP"], "Czech Republic"=>["CZE"], "Dahomey"=>["DAH"], "Denmark"=>["DEN"], "Djibouti"=>["DJI"], "Dominica"=>["DMA"], "Dominican Republic"=>["DOM"], "Ecuador"=>["ECU"], "Egypt"=>["EGY"], "England"=>["ENG"], "Eritrea"=>["ERI"], "El Salvador"=>["ESA"], "Spain"=>["ESP"], "Estonia"=>["EST"], "Ethiopia"=>["ETH"], "United Team of Germany"=>["EUA"], "Unified Team"=>["EUN"], "Falkland Islands"=>["FLK"], "Faroe Islands"=>["FRO"], "Fiji"=>["FIJ"], "Finland"=>["FIN"], "FINA Independent Athletes"=>["INA"], "France"=>["FRA"], "West Germany"=>["FRG"], "Rhodesia and Nyasaland"=>["FRN"], "Federation of South Arabia"=>["FSA"], "Federated States of Micronesia"=>["FSM"], "Gabon"=>["GAB"], "The Gambia"=>["GAM"],  "Gambia"=>["GAM"], "Great Britain"=>["GBR"], "Great Britain and Northern Ireland"=>["WCA"], "Guinea-Bissau"=>["GBS"], "Gold Coast"=>["GCO"], "East Germany"=>["GDR"], "Georgia"=> ["GEO"],"Georgia (country)"=>["GEO"], "Equatorial Guinea"=>["GEQ"], "Germany"=>["GER"], "Guernsey"=>["GUE"], "Ghana"=>["GHA"], "Gibraltar"=>["GIB"], "Greece"=>["GRE"], "Grenada"=>["GRN"], "Guatemala"=>["GUA"], "Guinea"=>["GUI"], "Guam"=>["GUM"], "Guyana"=>["GUY"], "Haiti"=>["HAI"], "British Honduras"=>["HBR"], "Hong Kong"=>["CGF"], "Honduras"=>["HON"], "Hungary"=>["HUN"], "Irish Free State"=>["IFS"], "Independent Asian Athletes"=>["IAA"], "Indonesia"=>["INA"], "India"=>["IND"], "Athletes from Kuwait"=>["IOC"], "Isle of Man"=>["IOM"], "Independent Olympic Participants"=>["IOP"], "Individual Paralympic Athletes"=>["IPA"], "Independent Paralympic Participants"=>["IPP"], "Ireland"=>["IRL"], "Iran"=>["IRN"], "Iraq"=>["IRQ"], "Iceland"=>["ISL"], "Israel"=>["ISR"], "Virgin Islands"=>["ISV"], "Italy"=>["ITA"], "British Virgin Islands"=>["IVB"], "Jamaica"=>["JAM"], "Jersey"=>["JEY"], "Jordan"=>["JOR"], "Japan"=>["JPN"], "Kazakhstan"=>["KAZ"], "Kenya"=>["KEN"], "Kyrgyzstan"=>["KGZ"], "Khmer Republic"=>["KHM"], "Kiribati"=>["KIR"], "South Korea"=>["KOR"], "Kosovo"=>["KOS"], "Saudi Arabia"=>["KSA"], "Kuwait"=>["KUW"], "Laos"=>["LAO"], "Latvia"=>["LAT"], "Libya"=>["LBA"], "Lebanon"=>["LIB"], "Liberia"=>["LBR"], "Saint Lucia"=>["LCA"], "Lesotho"=>["LES"], "Liechtenstein"=>["LIE"], "Lithuania"=>["LTU"], "Luxembourg"=>["LUX"], "Macau"=>["MAC"], "Madagascar"=>["MAD"], "Malaya"=>["MAL"], "Morocco"=>["MAR"], "Malaysia"=>["MAS"], "Malawi"=>["MAW"], "Moldova"=>["MDA"], "Maldives"=>["MDV"], "Mexico"=>["MEX"], "Mongolia"=>["MGL"], "Marshall Islands"=>["MHL"], "Mixed-NOCs"=>["MIX"], "Macedonia"=>["MKD"], "Mali"=>["MLI"], "Malta"=>["MLT"], "Montenegro"=>["MNE"], "Montserrat"=>["MSR"], "Monaco"=>["MON"], "Mozambique"=>["MOZ"], "Mauritius"=>["MRI"], "Mauritania"=>["MTN"], "Myanmar"=>["MYA"], "Namibia"=>["NAM"], "North Borneo"=>["NBO"], "Nicaragua"=>["NIC"], "New Caledonia"=>["NCL"], "Netherlands"=>["NED"], "Nepal"=>["NEP"], "Newfoundland"=>["NEW"], "Norfolk Island"=>["NFK"], "Nigeria"=>["NGR"], "Niger"=>["NIG"], "Northern Ireland"=>["NIR"], "Niue"=>["NIU"], "Northern Mariana Islands"=>["NMI"], "Norway"=>["NOR"], "Neutral Paralympic Athletes"=>["NPA"], "Northern Rhodesia"=>["NRH"], "Nauru"=>["NRU"], "New Zealand"=>["NZL"], "Olympic Athletes from Russia"=>["OAR"], "Oman"=>["OMN"], "Pakistan"=>["PAK"], "Panama"=>["PAN"], "Paraguay"=>["PAR"], "Peru"=>["PER"], "Philippines"=>["PHI"], "Palestine"=>["PLE"], "Palau"=>["PLW"], "Papua New Guinea"=>["PNG"], "Poland"=>["POL"], "Portugal"=>["POR"], "North Korea"=>["PRK"], "Puerto Rico"=>["PUR"], "French Polynesia"=>["PYF"], "Qatar"=>["QAT"], "Rhodesia"=>["RHO"], "Refugee Olympic Team"=>["ROT"], "Republic of China"=>["ROC"], "Romania"=>["ROU"], "South Africa"=>["SAF"], "Russia"=>["RUS"], "Rwanda"=>["RWA"], "Saar"=>["SAA"], "Samoa"=>["SAM"], "Sarawak"=>["SWK"], "Serbia and Montenegro"=>["SCG"], "Saint Christopher-Nevis-Anguilla"=>["SCN"], "Scotland"=>["SCO"], "Senegal"=>["SEN"], "Seychelles"=>["SEY"], "Singapore"=>["SIN"], "Saint Helena"=>["SHN"], "Saint Kitts and Nevis"=>["SKN"], "Sierra Leone"=>["SLE"], "Slovenia"=>["SLO"], "San Marino"=>["SMR"], "Solomon Islands"=>["SOL"], "Somalia"=>["SOM"], "Serbia"=>["SRB"], "Southern Rhodesia"=>["SRH"], "Sri Lanka"=>["SRI"], "South Sudan"=>["SSD"], "S\u00E3o Tom\u00E9 and Pr\u00EDncipe"=>["STP"], "Sudan"=>["SUD"], "Switzerland"=>["SUI"], "Suriname"=>["SUR"], "Saint Vincent and the Grenadines"=>["VIN"], "Slovakia"=>["SVK"], "Sweden"=>["SWE"], "Swaziland"=>["SWZ"], "Syria"=>["SYR"], "Tanganyika"=>["TAG"], "Tahiti"=>["TAH"], "Tanzania"=>["TAN"], "Turks and Caicos Islands"=>["TKS"], "Czechoslovakia"=>["TCH"], "Tonga"=>["TON"], "Thailand"=>["THA"], "Tajikistan"=>["TJK"], "Tokelau"=>["TKL"], "Turkmenistan"=>["TKM"], "East Timor"=>["TLS"], "Togo"=>["TOG"], "Chinese Taipei"=>["TPE"], "Trinidad & Tobago"=>["TTO"],"Trinidad and Tobago"=>["TTO"], "Tunisia"=>["TUN"], "Turkey"=>["TUR"], "Tuvalu"=>["TUV"], "United Arab Emirates"=>["UAE"], "United Arab Republic"=>["UAR"], "Uganda"=>["UGA"], "Ukraine"=>["UKR"], "Soviet Union"=>["URS"], "USSR"=>["URS"], "Uruguay"=>["URU"], "United States"=>["USA"], "Uzbekistan"=>["UZB"], "Vanuatu"=>["VAN"], "Venezuela"=>["VEN"], "Vietnam"=>["VIE"], "South Vietnam"=>["VNM"], "Upper Volta"=>["VOL"], "Wales"=>["WAL"], "Wallis and Futuna"=>["WLF"], "Western Samoa"=>["WSM"], "North Yemen"=>["YAR"], "Yemen"=>["YEM"], "South Yemen"=>["YMD"], "Yugoslavia"=>["YUG"], "Zaire"=>["ZAI"], "Zambia"=>["ZAM"], "Zimbabwe"=>["ZIM"], "Mixed team"=>["ZZX"]}

class Country
  class InvalidIoc < StandardError
    def initialize(country)
      super("Could not convert '#{country}' to IOC")
    end
  end
  
  class UnableToParse < StandardError
    def initialize(name)
      super("Unable to parse #{name} to a country name")
    end
  end
  
  attr_accessor :valid
  attr_accessor :gold, :silver, :bronze
  attr_accessor :ioc, :raw_name, :name, :note, :event, :raw_row
  attr_accessor :host, :template, :name_param, :version, :leading
  
  IOC = /^[A-Z]{3}$/
  MEDALS_REGEX = /\|+[\s']*([\.\d]+)[\s']*\|+[\s']*([\.\d]+)[\s']*\|+[\s']*([\.\d]+)/
  # this isolates the column that contains the text for the country name and templates
  # ISOLATE_COUNTRY = /\|[^\n\{\[]*(.*?)(?=\|\|)/
  ISOLATE_COUNTRY = /\|[^\{\[]*(.*?)(?=(?:\|\||\n))/
  # PLAIN_TEXT_COUNTRY = /\|\s*([A-Za-z\s]+)\s*\|/
  PLAIN_TEXT_COUNTRY = /\|\s*([A-Za-z\/\(\)\'\-\.\s\&]+)\s*\|/
  
  def initialize(row)
    return if row.match(/Total/i)
    @raw_row = row
    medals = row.match(MEDALS_REGEX)
    return unless medals
    @valid  = true
    @gold   = medals[1]
    @silver = medals[2]
    @bronze = medals[3]
    
    match = row.match(ISOLATE_COUNTRY)
    @raw_name = match[1] if match
    if @raw_name && @raw_name.empty?
      match = row.match(PLAIN_TEXT_COUNTRY)
      @raw_name = match[1] if match
    end
    
    @host = true if row.match?(/(:?ccccff|ccf)/i)
    @leading = true if row.match?(/E9D66B/i)
    self.parse_name!    
  end
  
  IOC_TEMPLATE = /\{([A-Z]{3})\}/
  BASIC_TEMPLATE = /\{\{([^\|]*?)\|([^\|]*)\}\}/
  THREE_BASIC_TEMPLATE = /\{\{([^\|]*?)\|([^\|]*)\|([^\|]*)\}\}/
  FOUR_BASIC_TEMPLATE = /\{\{([^\|]*?)\|([^\|]*)\|([^\|]*)\|([^\|]*)\}\}/
  PLAIN_TEXT = /[A-Za-z\s]+/
  
  def parse_name!
    # @ioc = 'AAA'
    # return
    if raw_name.match?(/{{GamesName|SOG/i)
      @ioc = 'AAA'
      return
    end
    return if raw_name.nil?
    if raw_name.match?(/\(([A-Z]{3})\)/)
      @ioc = raw_name.match(/\(([A-Z]{3})\)/)[1]
    elsif raw_name.match?(IOC_TEMPLATE)
      @ioc = raw_name.match(IOC_TEMPLATE)[1]
    elsif raw_name.match?(BASIC_TEMPLATE)
      match = raw_name.match(BASIC_TEMPLATE)
      @template = match[1]
      @name = match[2]
    elsif raw_name.match?(THREE_BASIC_TEMPLATE)
      match = raw_name.match(THREE_BASIC_TEMPLATE)
      @template = match[1]
      @name = match[2]
      @event = match[3]
    elsif raw_name.match?(FOUR_BASIC_TEMPLATE)
      match = raw_name.match(FOUR_BASIC_TEMPLATE)
      @template = match[1]
      @name = match[2]
      @event = match[3]
      @version = match[4]
    elsif raw_name.match?(PLAIN_TEXT)
    # else
      @name = @raw_name
      # @ioc = 'AAA' #if raw_name.match?(/\s*\[\[[\'\w\s\d]*\|{0,1}[\w\s\d]*\]\]/)
    else  
      puts self.inspect
      raise UnableToParse.new(raw_row)
    end
    @ioc = convert_to_ioc(@name) if @ioc.nil? 
  end
  
  def convert_to_ioc(country)
    country.strip!
    return country if country.nil? || country.match?(IOC)
    return 'AAA' if IOC_CODES[country].nil?
    # raise InvalidIoc.new(country) if IOC_CODES[country].nil?
    return IOC_CODES[country].first
  end

  SKIPS = ['MIX', 'ANA']
  AT_THE = /\[\[[\w\s]*at the[\w\s]*\|([\w\s]*)\]\]/
  
  def to_template(template, event)
    @ioc&.strip!
    @ioc = 'JPN' if @ioc == 'JAP'
    raise InvalidIoc.new('nil')  if ioc.nil?
    # raise InvalidIoc.new('BIR')  if @ioc == 'BIR'
    # raise InvalidIoc.new('NFI')  if @ioc == 'NFI'
    raise InvalidIoc.new(ioc) unless ioc.match?(/^[A-Z]{3}$/) || ioc.match?(/^\d+$/)
    @template = 'flagteam' if (@template && (@template.match?(/flagicon/i) || @template.strip.downcase == 'flagu'  || @template.strip.downcase == 'flag' || @template.strip.downcase == 'flagcountry'))
    @name_param = ''
    # @name_param = "{{#{@template}|#{@ioc}}}" if (@template && !@event && @template != template)
    # @name_param = "{{#{@template}|#{@ioc}|#{@event}}}" if (@template && @event && @event != event)
    # @name_param = "{{#{@template}|#{@ioc}|#{@event}|#{@version}}}" if (@version && @template && @event)
    # @name_param = '' if @name_param.match?(/\{\{flagcountry\|[A-Z]{3}\}\}/)
    # @name_param = '' if @name_param.match?(/\{\{flagteam\|[A-Z]{3}\}\}/)
    # @name_param = '{{flagteam|SFR Yugoslavia}}' if @ioc == 'SFR'
    # @name_param = '{{flagteam|FR Yugoslavia}}' if @ioc == 'FRY'
    # @name_param = "''#{@raw_name.delete("'").strip}''" if @raw_name.include?("''")
    # @name_param = @raw_name.strip if @ioc.match?(/([A-Z])\1\1/)
    # @name_param = '{{flagteam|Gotland}}' if @ioc == 'GOT'
    # @name_param = '{{flagteam|Menorca}}' if @ioc == 'MEN'
    # @name_param = '{{flagteam|Saint Helena}}' if @ioc == 'SHN'
    # @name_param = @raw_name if ioc.match?(/^\d+$/)
    # # @name_param = @raw_name.gsub('}(', '} (') if @raw_name.include?('(')
    # @name_param = @raw_name.gsub(/\}\}/, '}} ')
    # @name_param = @raw_name.gsub('}[', '} [') if @raw_name.include?('/')
    @name_param = @raw_name.gsub('}[', '} [') if @raw_name.include?('[')
    # @name_param = @raw_name.gsub(/\}\|\s*\d+/, '}')

    # @name_param = "{{GamesSport|#{@raw_name.match(AT_THE)[1]}|Format=d}}" if @raw_name.match?(AT_THE)
    # @name_param = "{{GamesSport|#{@raw_name.match(/\[\[(?:.*\|)?(.*)\]\]/)[1]}|Format=d}}" if @raw_name.match?(/\[\[(?:.*\|)?(.*)\]\]/) 
    # @name_param = "{{GamesSport|#{@raw_name}|Format=d}}" 
    # @name_param = "{{GamesSport|Athletics|Format=d}}" 
    @name_param = @raw_name if @name_param.empty?
    
    @name_param.gsub!('25px]] [[','')
    
    note_param = ''
    note_param = @raw_row.match(/(\{\{efn[^}]*\}\})/)[1] if @raw_row.match?(/(\{\{efn[^}]*\}\})/)
    note_param = @raw_row.match(/(\{\{ref[^}]*\}\})/i)[1] if @raw_row.match?(/(\{\{ref[^}]*\}\})/i)
    
    # raise InvalidIoc('SKIPS') if SKIPS.include?(@ioc)
    return '' if ioc.nil?
    justify = 2
    ioc_just = 2
    result = ''
    result += " | gold_#{@ioc.ljust(ioc_just)} = #{@gold.ljust(justify)}"
    result += " | silver_#{@ioc.ljust(ioc_just)} = #{@silver.ljust(justify)}"
    result += " | bronze_#{@ioc.ljust(ioc_just)} = #{@bronze.ljust(justify)}"
    result += " | name_#{@ioc.ljust(ioc_just)} = #{@name_param}" unless @name_param.empty?
    result += " | note_#{@ioc} = #{note_param}" unless note_param.empty?
    result += " | host_#{@ioc} = yes " if @host
    result += " | leading_#{@ioc} = yes " if @leading
    # result += " | note_#{@ioc} = {{double-dagger}}" if @raw_name.include?('‡')
    result += " | skip_#{@ioc} = yes" if SKIPS.include?(@ioc)
    result += "\n" unless result.empty?
    result
  end
  
  def generate(**args)
    @gold = args[:gold]
    @silver = args[:silver]
    @bronze = args[:bronze]
    @ioc = args[:ioc]
    @name = args[:name]
    @note = args[:note]
    @host = args[:host]
    @raw_name = args[:raw_name]
  end
end