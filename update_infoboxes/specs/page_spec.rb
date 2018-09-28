require 'rspec'
require '../page'
require '../category'

describe 'page' do
  describe 'parse_page' do
    it "returns -1 if the text does not contain 'infobox'" do
      text = "this is just a test"
      expect(Page.parse_page(text,'TITLE',Category::INFOBOX)).to be nil
    end
  end
  describe 'parse_talk_page' do
    describe 'default regex' do
      it 'raises an error if the needs-infobox text is not found' do
        text = 'this page needs an infobox'
        expect{Page.parse_talk_page(text,Category::TALK_PAGE)}.to raise_error(Page::NeedsInfoboxNotFound)
      end
      it 'replaces the text at the end of a template' do
        text   = '{{WikiProject Books|class=stub|needs-infobox   = yes }}'
        result = '{{WikiProject Books|class=stub}}'

        expect(Page.parse_talk_page(text,Category::TALK_PAGE)).to eq(result)
      end
      it 'replaces the text in the middle of a template' do
        text   = '{{WikiProject Books|class=stub|needs-infobox   = yes |importance = HIGHHHH}}'
        result = '{{WikiProject Books|class=stub|importance = HIGHHHH}}'

        expect(Page.parse_talk_page(text,Category::TALK_PAGE)).to eq(result)
      end
      it 'replaces shortened version of a template' do
        text   = '{{WikiProject Books|class=stub|needs-infobox   = y |importance = HIGHHHH}}'
        result = '{{WikiProject Books|class=stub|importance = HIGHHHH}}'

        expect(Page.parse_talk_page(text,Category::TALK_PAGE)).to eq(result)
      end
      it 'replaces unusual formats' do
        text   = <<~TEXT
{{{{WikiProjectBannerShell|1=
{{WikiProject Novels |class=start |importance=Top |needs-infobox=-cover=1st |19thC-task-force=yes}}
{{WikiProject Novels |class=start |importance=Top |needs-infobox=-cover=1st }}
}}
        TEXT
        result   = <<~TEXT
{{{{WikiProjectBannerShell|1=
{{WikiProject Novels |class=start |importance=Top |19thC-task-force=yes}}
{{WikiProject Novels |class=start |importance=Top }}
}}
        TEXT

        expect(Page.parse_talk_page(text,Category::TALK_PAGE)).to eq(result)
      end
      it 'replaces the text in multiple places' do
        text   = <<~TEXT
{{WikiProjectBannerShell|1=
{{WikiProject Perl}}
{{WikiProject Computing|  needs-infobox = yes
|class=stub|importance=low}}
{{WikiProject Books|class=stub|needs-infobox=yes}}
{{project|
|needs-infobox=1st
}}
}}
        TEXT
        result   = <<~TEXT
{{WikiProjectBannerShell|1=
{{WikiProject Perl}}
{{WikiProject Computing|class=stub|importance=low}}
{{WikiProject Books|class=stub}}
{{project|
}}
}}
        TEXT
        expect(Page.parse_talk_page(text,Category::TALK_PAGE)).to eq(result)
      end
    end
  end
end
