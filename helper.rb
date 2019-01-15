require 'csv'
require 'normalize_country'
require 'HTTParty'
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'uri'
require 'colorize'
require 'json'
require 'fileutils'
require 'open-uri'
require 'googlebooks'
require 'clipboard'
# encoding: utf-8

Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each do |helper|
  require helper
end

class Helper
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  class NoResults < StandardError
    def initialize(url)
      super("No results were found at #{url}")
    end
  end

  def self.get_client
    Helper.read_env_vars(file = '../vars.csv')
    client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
    client.log_in ENV['USERNAME'], ENV['PASSWORD']
    client
  end

  def self.get_wmf_pages(url)
    begin
      Timeout.timeout(120) do
        @content = HTTParty.get(url)
      end
    rescue Timeout::Error
      puts 'ERROR: Took longer than 120 seconds to get content Script aborting.'
      exit(0)
    end
    
    results = @content["*"].first['a']['*'].map do |i|
      i["title"].gsub('_', ' ')
    end
    raise NoResults.new(url) if results.empty?
    results
  end  
  # 
  # def self.get_category_pages(category)
  #   category = 'Category:' + category unless category.start_with?('Category:')
  #   
  #   @content = HTTParty.get("https://en.wikipedia.org/w/api.php?action=query&format=json&list=categorymembers&cmtitle=#{URI::encode(category)}&cmlimit=500")
  #   @content['query']['categorymembers'].map{ |member| member['title'].encode('utf-8') }
  #   
  # end
  
  def self.read_env_vars(file = 'vars.csv')
    vars = CSV.read(file)
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
    return 'TPE' if country == 'Chinese Taipei'
    return 'SCO' if country == 'Scotland'
    return 'WAL' if country == 'Wales'
    return 'IOM' if country == 'Isle of Man'
    return 'NIR' if country == 'Northern Ireland'
    return 'ENG' if country == 'England'
    return 'FYG' if country == 'FR Yugoslavia'
    return 'YUG' if country == 'Yugoslavia'
    return 'YUG' if country == 'SFR Yugoslavia'
    return 'URS' if country == 'Soviet Union'
    return 'FRG' if country == 'West Germany'
    return 'GDR' if country == 'East Germany'
    return 'WSM' if country == 'Western Samoa'
    code = NormalizeCountry(country, to: :ioc)
    # raise ArgumentError "Invalid country '#{country}' for IOC" if code.nil?
    code
  end

  def self.print_link(title)
    puts "\t#{"https://en.wikipedia.org/wiki/#{title.gsub(/\s/,'_')}"}"
  end
  
  def self.page_history(title)
    puts "\t#{URI::encode("https://en.wikipedia.org/w/index.php?title=#{title}&action=history")}"
  end

  def self.print_message(message)
    puts "\t#{message}".colorize(:red)
  end
  
  
  ARGUMENT_REGEX = /((?:\||\A) *\K[^{\[|]*(?:(?:({{(?:[^{}]*+|\g'2')*}})|(\[{1,2}(?:[^\[\]]*+|\g'3')*\]{1,2}))[^{\[|]*)*)/
  
  # ARGS = /\s*([\w\s\-]*)=\s*(.*)\n*(?:\}\})?/
  ARGS = /\s*([\w\s\-]*)=\s*([\w\W]*)\n*(?:\}\})?/
  def self.parse_template(text)
    text.gsub!(/<!--.*-->/, '')
    text = text.strip[2..-3]
    # puts "##{text}#"
    results = Hash.new('')
    args = text.split(/\n\|/).drop(1) 
    # args = text.split(/\s*\|\s*(?![^{\[]*[\]}])/).drop(1)
    args = text.scan(ARGUMENT_REGEX).drop(1)
    
    args.each_with_index do |arg, index|
      arg = arg.first.strip
      arg = arg[1..-1] if arg[0] == '|'
      if arg.include?('=')
        # puts "##{arg}#"
        param = arg.match(ARGS)[1].strip
        value = arg.match(ARGS)[2].strip
        value.gsub!(/<!--.*-->/, '')
        results[param] = value
      else
        results[(index+1).to_s] = arg.strip
      end
    end
    results.each do |key, val|
      results[key] = '' if val.start_with?('|')
    end
    results
  end

  def self.get_custom_value(prompt)
    raise UnresolvedCase.new('Skipping') unless $allow_manual_checks
    # raise UnresolvedCase.new('Skipping request for custom value')
    puts prompt.colorize(:red)
    puts '"X" will raise error'.colorize(:red)
    result = gets.strip.upcase
    raise UnresolvedCase.new('Skipping') if result == 'X'
    result
  end
end