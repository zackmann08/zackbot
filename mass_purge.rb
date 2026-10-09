require 'net/http'
require 'json'
require 'uri'
require 'mediawiki_api'

uri = URI('https://en.wikipedia.org/w/api.php')

params = {
  action: 'query',
  list: 'embeddedin',
  eititle: 'Template:Infobox medical details', 
  eilimit: 'max',
  format: 'json',
  formatversion: '2'
}

results = []

loop do
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)
  
  unless response.is_a?(Net::HTTPSuccess)
    puts "HTTP Error: #{response.code}"
    break
  end
  
  data = JSON.parse(response.body)
  
  
  if data['query'] && data['query']['embeddedin']
    results.concat(data['query']['embeddedin'])
  end
  
  if data['continue']
    params.merge!(data['continue'])
  else
    break
  end
end

# Print the first 5 titles to verify it's working
if results.any?
	client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
  	results.each do |page|
  		client.action(
	  		:purge,
		  	titles: page['title'],
		  	forcelinkupdate: '1',
		  	token_type: false # Don't waste a request fetching an edit token
		)
  	end
end