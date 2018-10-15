module Book
  
  BOOK_PROJECT = "{{WikiProject Books|class=File}}"
  ISBN_REGEX = /\|\s*isbn\s*\=\s*([0-9\-]+)/i
  OCLC_REGEX = /\|\s*oclc\s*\=\s*([a-z0-9\-]+)/i
  
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
  
  
  def get_google_book_at(author, title)
    begin
      google_response = GoogleBooks.search("#{author} #{title}")
      # puts google_response.inspect
      if google_response.total_items==0
        # puts google_response.inspect
        # Helper.print_message("Google Books returned no results")
        return nil
      end
      image_url = google_response.first.image_link(zoom: 1)
        # Helper.print_message("Google Books has no image") if image_url.nil?
    rescue Encoding::CompatibilityError
      return nil
    end
    image_url
  end
  
  def get_open_library(isbn)
    response = HTTParty.get("https://openlibrary.org/api/books?bibkeys=ISBN:#{isbn}")
    result = response.body.delete('var _OLBookInfo = ').chomp(';')
    begin 
      parsed_result = JSON.parse(result)
    rescue JSON::ParserError
      # Helper.print_message("JSON parse caused an error")
      return nil
    end
    if parsed_result.empty?
      # Helper.print_message('No results from open library')
      return nil
    end
    begin
      image_id = parsed_result["SN:#{isbn}"]["thumbilul"].match(/\d+/)
    rescue NoMethodError
      # Helper.print_message("OpenLibrary returned an invalid response: #{parsed_result}")
      return nil
    end
    "https://covers.openlibrary.org/b/id/#{image_id}-L.jpg"
  end
  def get_open_library_oclc(oclc)
    response = HTTParty.get("https://openlibrary.org/api/books?bibkeys=OCLC:#{oclc}")
    result = response.body.delete('var _OLBookInfo = ').chomp(';')
    begin 
      parsed_result = JSON.parse(result)
    rescue JSON::ParserError
      # Helper.print_message("JSON parse caused an error")
      return nil
    end
    if parsed_result.empty?
      # Helper.print_message('No results from open library')
      return nil
    end
    begin
      image_id = parsed_result["OCLC:#{oclc}"]["thumbnail_url"].match(/\d+/)
    rescue NoMethodError
      # Helper.print_message("OpenLibrary returned an invalid response: #{parsed_result}")
      return nil
    end
    "https://covers.openlibrary.org/b/id/#{image_id}-L.jpg"
  end
  
  def get_google_books(isbn)
    google_response = GoogleBooks.search("isbn:#{isbn.gsub('-','')}")
    # puts google_response.inspect
    if google_response.total_items==0
      # puts google_response.inspect
      # Helper.print_message("Google Books returned no results")
      return nil
    end
    image_url = google_response.first.image_link(zoom: 1)
    # Helper.print_message("Google Books has no image") if image_url.nil?
    image_url
  end
  
  def get_archive_org(isbn)
    response = HTTParty.get("https://archive.org/services/book/v1/do_we_have_it/?isbn=#{isbn}")
    results = response.parsed_response['ia_identifiers']
    if results.empty?
      # Helper.print_message('No results from archive.org')
      return nil    
    end
    id = results.first['ia_identifier']
    "https://archive.org/services/img/#{id}"
  end


  end