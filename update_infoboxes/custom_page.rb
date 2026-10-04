module CustomPage
  class NeedsInfoboxNotFound < StandardError; end
  INFOBOX = /infobox/i
  def self.parse_page(full_text, title, infobox_regex)
    if full_text.match?(infobox_regex)
      return "Has Infobox"
    else
      return nil
    end
  end
  
  NEEDS_INFOBOX = /\|\s*(?:needs\-infobox|infoboxneeded|no\-infobox)\s*=\s*[^\}\|]*/im
  INFOBOX_REQUEST = /\{\{(?:Infobox requested|Infobox missing|Infobox needed|Infobox wanted|Need infobox|Needinfobox|Needs infobox|Noinfobox|Reqinfobox)(?:\|[^}]+)?\s*\}\}/im
  def self.parse_talk_page(talk_page_text) #, talk_page_regex)
    matched = false
    new_text = talk_page_text.dup

    # Modern multi-line variant to strip the parameter flag even if it ends with a newline
    # This addresses the problem where a line break breaks [^\}\|]*
    # flexible_talk_regex = /\|\s*(?:needs-infobox|infoboxneeded|infobox|needs-cultivar-infobox|no-infobox|ibox)\s*=\s*[^}|]*\s*/im

    # if new_text.match?(flexible_talk_regex)
    #   new_text.gsub!(flexible_talk_regex, '')
    #   matched = true
    # end

    if new_text.match?(INFOBOX_REQUEST)
      new_text.gsub!(INFOBOX_REQUEST, '')
      matched = true
    end
    if new_text.match?(NEEDS_INFOBOX)
      new_text.gsub!(NEEDS_INFOBOX, '')
      matched = true
    end

    raise NeedsInfoboxNotFound unless matched

    # Clean up excess empty spacing left over from removed elements
    new_text.gsub(/\n{3,}/, "\n\n").strip
  end

end



