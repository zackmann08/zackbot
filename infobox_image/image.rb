module Image
  BASE_REGEX = /(?:image|file)\:([^\|]*)/i
  CAPTION_REGEX = /(?:thumb|frameless|\d+px)/i
  def parse_image(text)
    return nil unless text.match?(BASE_REGEX)
    text = text.delete('[').delete(']').split('|')
    file = text.first.sub(/.*?\:/,'')
    caption = text.last
    caption = nil if caption.match?(CAPTION_REGEX)
    return file, caption
  end
end