require './spec_helper'

describe 'initialize' do
  it 'assigns the raw text' do
    expect(Page.new('This is my text')).to have_attributes(raw_text: 'This is my text')
  end
end

describe 'get_templates' do
  it 'finds a basic template' do
    text   = <<~TEXT
{{WikiProjectBannerShell|1=
{{WikiProject Perl}}
{{WikiProject Computing}}
{{WikiProject Books|class=stub|needs-infobox=yes}}
{{WikiProject Books|class=stub|infoboxneeded=yes}}
}}
    TEXT
    result   = ['{{WikiProject Books|class=stub|needs-infobox=yes}}','{{WikiProject Books|class=stub|infoboxneeded=yes}}']
    expect(Page.new(text).get_templates('WikiProject Books')).to eq (result)
  end
  
  it 'finds templates within other templates basic template' do
    text   = <<~TEXT
{{infobox
 | foo = bar
 | height = {{convert|5|kg|abbr=on}}
}}
Then there is some more text
    TEXT
    result   = ['{{convert|5|kg|abbr=on}}']
    expect(Page.new(text).get_templates('convert')).to eq (result)
  end
  
  it 'finds templates ignoring case' do
    text   = <<~TEXT
{{infobox
 | foo = bar
 | height = {{convert|5|kg|abbr=on}}
}}
Then there is some more text {{Convert|2|feet|abbr=on}}
    TEXT
    result   = ['{{convert|5|kg|abbr=on}}', '{{Convert|2|feet|abbr=on}}']
    expect(Page.new(text).get_templates(/convert/i)).to eq (result)
  end
  
end
