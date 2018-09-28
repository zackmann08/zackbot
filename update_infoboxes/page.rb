module Page
  class NeedsInfoboxNotFound < StandardError; end
  INFOBOX = /infobox/i
  def self.parse_page(full_text, title, infobox_regex)
    if full_text.match?(infobox_regex)
      Helper.print_message('HAS INFOBOX')
      Helper.print_link(title)
      return "Has Infobox"
    else
      return nil
    end
  end
  
  NEEDS_INFOBOX = /\|\s*needs-infobox\s*=\s*[^\}\|]*/
  def self.parse_talk_page(talk_page_text,talk_page_regex)
    raise NeedsInfoboxNotFound unless talk_page_text.match?(talk_page_regex)
    talk_page_text.gsub(talk_page_regex,'')
  end

end


