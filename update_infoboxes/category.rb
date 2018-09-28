class Category
  TALK_PAGE = /\|\s*needs-infobox\s*=\s*[^\}\|]*/
  INFOBOX = /infobox/i

  attr_accessor :name, :url, :infobox_regex, :talk_page_regex

  def initialize(row)
    @name = row['name']
    @url = row['url'].strip
    
    if row['infobox'].nil?
      @infobox_regex = INFOBOX
    else
      @infobox_regex = Regexp.new(row['infobox'],Regexp::IGNORECASE)
    end
    if row['talkpage'].nil?
      @talk_page_regex = TALK_PAGE
    else
      @talk_page_regex = Regexp.new(row['talkpage'],Regexp::IGNORECASE)
    end
  end
  
  def self.parse_category(category, client)
    infobox_regex = category.infobox_regex
    talk_page_regex = category.talk_page_regex

    content = HTTParty.get(category.url.strip)
    pages = content["*"].first['a']['*'].map do |i|
      i["title"].gsub('_', ' ')
    end
    puts "Total to do: #{pages.size}".colorize(:blue)
    pages.each do |title|
      puts title

      full_text = client.get_wikitext(title).body
      if Page.parse_page(full_text,title,infobox_regex)
        talk_title = "Talk:#{title}"
        begin
          talk_page_text = client.get_wikitext(talk_title).body
          new_text = Page.parse_talk_page(talk_page_text,talk_page_regex)
          client.edit(title: talk_title, text: new_text, summary: "page has an infobox")
          puts "- success".colorize(:green)
          sleep 5
        rescue Page::NeedsInfoboxNotFound => e
          Helper.print_message('Raised: "NeedsInfoboxNotFound"')
          Helper.print_link(talk_title)
          next
        end
      end
    end
  end
end
