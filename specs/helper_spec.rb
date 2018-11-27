require './spec_helper'

# describe 'get_wmf_pages' do
#   #TODO: use VCR!
#   it 'raises an error for no results' do
#     url = "https://petscan.wmflabs.org/?psid=6000630&format=json"
#     expect{Helper.get_wmf_pages(url)}.to raise_error(Helper::NoResults)
#   end
# end
# 


describe 'parse_template' do
  it 'works for a very simple template' do
    text = <<~TEXT
{{Infobox royalty
| name = Louis
| title = Prince Napoléon   
}}
    TEXT
    result = {'name' => 'Louis', 'title' => 'Prince Napoléon' }
    expect(Helper.parse_template(text)).to eq(result)
  end 
  it 'works for parmas on the same line' do
    text = <<~TEXT
{{Some infobox royalty
| name = Louis
| title = Prince Napoléon 
| a = AA | b =  BB
}}
TEXT
    result = {'name' => 'Louis', 'title' => 'Prince Napoléon', 'a' => 'AA', 'b' => 'BB' }
    expect(Helper.parse_template(text)).to eq(result)
  end 
  it 'works with a template and a link' do
    text = <<~TEXT
{{Some infobox royalty|testing
| name = Louis
| title = Prince Napoléon 
| a = [[AA|aa]] | b =  {{convert|12|m|abbr=on}}
}}
TEXT
    result = {'1' => 'testing', 'name' => 'Louis', 'title' => 'Prince Napoléon', 'a' => '[[AA|aa]]', 'b' => '{{convert|12|m|abbr=on}}' }
    expect(Helper.parse_template(text)).to eq(result)
  end 
  it 'works for a multi-line template' do
    text = <<~TEXT
{{Some infobox royalty|testing
| name = Louis
| title = Prince Napoléon 
| elevation_imperial_note = <ref name="usgs">{{cite web|url={{Gnis3|1802764}}|title=USGS detail on Newtown|accessdate=2007-10-21}}</ref>
| a = [[AA|aa]] | b =  {{cite
|title=TITLE
|author=AUTHOR}}
}}
TEXT
    result = {'1' => 'testing', 'name' => 'Louis', 'title' => 'Prince Napoléon', 'elevation_imperial_note' => '<ref name="usgs">{{cite web|url={{Gnis3|1802764}}|title=USGS detail on Newtown|accessdate=2007-10-21}}</ref>', 'a' => '[[AA|aa]]', 'b' => "{{cite\n|title=TITLE\n|author=AUTHOR}}" }
    expect(Helper.parse_template(text)).to eq(result)
  end 
  
  
  it 'works for external links' do
    text = <<~TEXT
{{Geobox
| Settlement
| website  = testing [Google.com google]
| native_name  = 
}}
TEXT
    result = {'1' => 'Settlement', 'website' => 'testing [Google.com google]', 'native_name' => ''}
    expect(Helper.parse_template(text)).to eq(result)
  end
  
  
#   it 'works for numbered parameters' do
#     text = <<~TEXT
# {{convert|123|in|cm|abbr=on}}
# TEXT
#     result = {'1' => '123', '2' => 'in', '3' => 'cm', 'abbr' => 'on' }
#     expect(Helper.parse_template(text)).to eq(result)
#   end
#   it 'works for numbered parameters' do
#     text = <<~TEXT
# {{convert|123|in|cm|abbr=on}}
# TEXT
#     result = {'1' => '123', '2' => 'in', '3' => 'cm', 'abbr' => 'on' }
#     expect(Helper.parse_template(text)).to eq(result)
#   end
  
  
  
end