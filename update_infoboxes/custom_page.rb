module CustomPage
  class NeedsInfoboxNotFound < StandardError; end
  INFOBOX = /infobox/i
  def self.parse_page(full_text, title, infobox_regex)
    if full_text.match?(infobox_regex)
      # Helper.print_message('HAS INFOBOX')
      # Helper.print_link(title)
      return "Has Infobox"
    else
      return nil
    end
  end
  
  NEEDS_INFOBOX = /\|\s*needs-infobox\s*=\s*[^\}\|]*/
  INFOBOX_REQUEST = /\{\{(?:Infobox requested|Infobox missing|Infobox needed|Infobox requested|Infobox wanted|Need infobox|Needinfobox|Needs infobox|Noinfobox|Reqinfobox)\}\}/i
  def self.parse_talk_page(talk_page_text,talk_page_regex)
    if talk_page_text.match?(talk_page_regex)
      return talk_page_text.gsub(talk_page_regex,'')
    end
    if talk_page_text.match?(INFOBOX_REQUEST)
      return talk_page_text.gsub(INFOBOX_REQUEST, '')
    end
    raise NeedsInfoboxNotFound unless talk_page_text.match?(talk_page_regex)
  end

end



