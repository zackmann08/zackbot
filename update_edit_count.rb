#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'

REGEX = /Total edits.*\n.*<strong>(?<number>[0-9,]*)/

Helper.read_env_vars

puts "Getting count for #{ENV['USERNAME']}"

begin
  Timeout.timeout(40) do
    @content = HTTParty.get("https://tools.wmflabs.org/supercount/index.php?user=#{ENV['USERNAME']}&project=en.wikipedia")
  end
rescue Timeout::Error
  puts 'ERROR: Took longer than 40 seconds to get edit count. Script aborting.'
  exit(0)
end

results = @content.match(REGEX)

puts "Updating count to #{results[:number]}"

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'

client.log_in ENV['USERNAME'], ENV['PASSWORD']

client.edit(title: "User:#{ENV['USERNAME']}/edit count", text: results[:number].delete(','))
