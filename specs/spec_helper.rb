require 'rspec'
require '../helper.rb'

Dir[File.expand_path('../helpers/*.rb', File.dirname(__FILE__))].each do |helper|
  require helper
end

