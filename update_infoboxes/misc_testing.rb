require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require_relative './page'
require_relative './category'

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

categories = CSV.foreach('data.csv', {headers: true}).map do |row|
  Category.new(row)
end
puts categories.inspect

categories.each do |category|
  puts "Category: #{category.name}".colorize(:blue)

  Category.parse_category(category, client)

end
