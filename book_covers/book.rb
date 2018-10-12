module Book
  BOOK_PROJECT = "{{WikiProject Books|class=File}}"

  IMAGE_REGEX = /(\s*\|\s*image\s*=)\s*/
  def comment(title, author, url)
    author += ']]' if author[0,2] == '[[' && author.chars.last(2).join != ']]'
    "==Summary==
{{Non-free use rationale book cover
| Article = #{title.strip}
| Title   = [[#{title.strip}]]
| Author  = #{author}
| Source  = #{url}
| Use     = Infobox
}}

==Licensing==
{{Non-free book cover|image has rationale=yes}}"
  end
  
  
  
  
end