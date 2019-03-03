# encoding: utf-8
require '../helper'

class Team

  attr_accessor :raw_row
  attr_accessor :raw_name, :name, :pos
  attr_accessor :win, :draw, :loss, :adjust, :hth
  attr_accessor :gf, :ga, :status, :color, :nat, :wpts

  def initialize(row)
    row.gsub!(/&nbsp;/i, ' ')
    @raw_row = row
    row = Helper.parse_template(row)

    # raise Helper::UnresolvedCase.new('Contains points note that must be manually entered: hth_AAA') unless row['pn'].empty?
    
    # raise Helper::UnresolvedCase unless row['bp'].empty?
    # raise Helper::UnresolvedCase unless row['gavg'].empty?
    
    raise Helper::UnresolvedCase unless row['rows'].empty?
    # raise Helper::UnresolvedCase unless row['var'].empty?
    # raise Helper::UnresolvedCase unless row['wpts'].empty?
    
    @raw_row_hash = row
    @raw_name = row['t']
    @raw_status = row['status']
    
    @win  = row['w']
    @draw = row['d']
    @loss = row['l']
    @gf   = row['gf']
    @ga   = row['ga']
    @nat  = row['nat']
    @wpts = row['wpts']
    @pos  = row['p']
    @hth  = row['pn']
    @color= row['bc'] unless row['bc'].empty?
    @adjust = row['dp'].to_i + row['bp'].to_i
    
    @status = 'PP' if (@color && @color.match?(/#D0F0C0/i))
    @status = 'C' if (@color && @color.match?(/#ACE1AF/i))
    @status = 'RR' if (@color && @color.match?(/#FFCCCC/i))
    
    if row['nat'].empty?
      @name = self.class.parse_raw_name(@raw_name)
    else
      @name = row['nat'].upcase
    end
    
    parse_status!
    parse_color! unless @color.nil?
  end
  
  COLOR_REGEX = /^(?:[A-F0-9]{6}|[A-F0-9]{3})$/i
  def parse_color!
    @color = "##{@color}" if @color.strip.match?(COLOR_REGEX)
  end
  
  # STATUS_REGEX = /\|\s*(champion|promoted|qualified|playoffwinner|tournamentqualified|advances|relegationqualified|disqualified|eliminated|relegated|allsvenskanchampion|swedishchampion)\s*=\s*[A-Za-z0-9][^\|{}]*(?:\||\}\})/
  STATUS_REGEX =       /\|\s*(champion|promoted|qualified|playoffwinner|tournamentqualified|advances|relegationqualified|disqualified|eliminated|relegated|allsvenskanchampion|swedishchampion)\s*=\s*[A-Za-z0-9\s]*\s*(?!\||\}\})/
  def parse_status!
    if @raw_row.match?(STATUS_REGEX)
      @status = ''
      @raw_row.scan(STATUS_REGEX).each do |status|
        status = status.first
        case status
        when 'allsvenskanchampion', 'swedishchampion'
          raise Helper::UnresolvedCase.new('Status not dealt with')
        when 'playoffwinner'
          @status += 'O'
        when 'relegationqualified'
          @status += 'RQ'
        else
          @status += status[0].upcase
        end
      end
    end
  end
  

  LINK_REGEX = /\[\[(?:[^\|]*\|)?(.*)\]\]/ #Gives me the displayed part of a link [[(foo)]] or [[foo|(bar)]]
  # FLAG_REGEX = /\{\{(?:fbw|flag)\|([A-Z]{2,3})\}\}/
  
  #TODO: What if the name is a flag template? {{fb|USA}}
  def self.parse_raw_name(name)
    # puts name
    name.gsub!(/'{3}/, '')
    # puts name
    if name.match?(LINK_REGEX)
      parse_name(name.match(LINK_REGEX)[1])
    # elsif name.match?(FLAG_REGEX)
    #   parse_name(name.match(FLAG_REGEX)[1])
    else
      parse_name(name)
    end
  end
  
  SINGLE_WORD_REGEX = /^[[:alpha:]]*$/
  DUAL_WORD_REGEX = /^([[[:punct:]][[:alpha:]]]+)[\s\-]+([[[:punct:]][[:alpha:]]]+)$/
  MULTI_WORD_REGEX = /^([[[:punct:]][[:alpha:]]]+)\s+([[[:punct:]][[:alpha:]]]+)\s+([[[:punct:]][[:alpha:]]]+).*$/
  FLAG_REGEX = /^\{\{(?:fb|fbw|flag|futsal)\|([A-Z]{3})\}\}$/i
  def self.parse_name(name)
    
    temp_name = name.gsub(/\([[:alpha:]]+\)/, '')
    temp_name.strip!

    return Helper.get_custom_value("raw name '#{temp_name}' is too short. please enter a value:") if temp_name.length < 3
    
    return 'OCT' if temp_name.match?(/de Octubre/)
    if temp_name.match?(/\d/)
      return Helper.get_custom_value("Name: '#{temp_name}' contains numbers, please enter a value:")
    end
    if temp_name.match?(SINGLE_WORD_REGEX)
      return temp_name[0,3].upcase
    elsif temp_name.match?(DUAL_WORD_REGEX)
      match = temp_name.match(DUAL_WORD_REGEX)
      return match[1][0].upcase + match[2][0].upcase
    elsif temp_name.match?(MULTI_WORD_REGEX)
      match = temp_name.match(MULTI_WORD_REGEX)
      return match[1][0].upcase + match[2][0].upcase + match[3][0].upcase
    elsif temp_name.match?(FLAG_REGEX)
      match = temp_name.match(FLAG_REGEX)
      return match[1]
    end
    return Helper.get_custom_value("Name: '#{temp_name}' was not parsed, please enter a value:")
    raise Helper::UnresolvedCase.new("Name '#{temp_name}' was not parsed")
  end


end