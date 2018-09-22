require 'csv'
require 'normalize_country'

class Helper
  def self.read_env_vars
    vars = CSV.read('vars.csv')
    vars.each do |var, value|
      ENV[var] = value
    end
  end

  def self.split_dep_vars(s) #team, years, split = "<br>", type = "coach")
    parsed = s.match(/\|\s*(?<type>.*)\_teams\s*=\s*(?<team>.*)\n*\|\s*.*\_years\s*=\s*(?<years>.*)/)

    split = s.match(/<br[\s\/]*>/)[0]

    team = parsed[:team].split(split)
    years = parsed[:years].split(split)
    type = parsed[:type]

    result = ""
    team.each_with_index do |team, count|
      result+="| #{type}_team#{count+1}  = #{team}\n| #{type}_years#{count+1} = #{years[count]}\n"
    end
    puts result
  end
  
  def self.to_ioc(country)
    return 'GBR' if country == 'Great Britain'
    return 'TCH' if country == 'Czechoslovakia'
    code = NormalizeCountry(country, to: :ioc)
    # raise ArgumentError "Invalid country '#{country}' for IOC" if code.nil?
    code
  end
end
