require 'rspec'
require 'CSV'
require '../category'

HEADER = %w(name url infobox talkpage)

describe 'category' do
  describe 'initialize' do
    it 'uses default arguments' do
      row = CSV::Row.new(HEADER, ['test','www.google.com',nil,nil])
      category = Category.new(row)
      expect(category).to have_attributes(
            name: 'test',
            url: 'www.google.com',
            infobox_regex: Category::INFOBOX, 
            talk_page_regex: Category::TALK_PAGE
        )
    end
    it 'uses custom argument infobox' do
      row = CSV::Row.new(HEADER, ['test','www.google.com','\t\d\w*',nil])
      category = Category.new(row)
      expect(category).to have_attributes(
            url: 'www.google.com',
            infobox_regex: /\t\d\w*/i, 
            talk_page_regex: Category::TALK_PAGE
        )
    end
    it 'uses default argument talk page' do
      row = CSV::Row.new(HEADER, ['test','www.google.com',nil,'\d*\s\s'])
      category = Category.new(row)
      expect(category).to have_attributes(
            url: 'www.google.com',
            infobox_regex: Category::INFOBOX, 
            talk_page_regex: /\d*\s\s/i
        )
    end
  end
end