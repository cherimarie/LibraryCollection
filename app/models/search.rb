class Search
  require 'net/http'

  def self.scrape(isbn)
    if (book = Book.find_by(isbn: isbn)) then
      book.update_attributes(count: book.count + 1)
      return book
    end

    scraped_data = []
    google_info = google_api(isbn)
    scraped_data << google_info if google_info
    good_reads_info = good_reads_api(isbn)
    scraped_data << good_reads_info if good_reads_info
    world_cat_info = world_cat_api(isbn)
    scraped_data << world_cat_info if world_cat_info

    return nil if scraped_data.empty?

    joined_hash = join_hashes(scraped_data)
    return create_book(joined_hash, isbn)
  end

  private

  def self.join_hashes(hashes)
    main_hash = hashes.shift
    unless hashes.empty?
      hashes.each do |data|
        data.keys.each do |key|
          main_hash[key] = data[key] unless main_hash[key]
        end
      end
    end

    return main_hash
  end

  def self.create_book(book_info, isbn)
    b = Book.new
    b.title = book_info["title"]
    b.publisher = book_info["publisher"]
    b.publish_date = book_info["publish_date"]
    b.language = book_info["language"]
    b.pages = book_info["pages"]
    b.isbn = isbn
    authors = book_info["authors"]
    if authors
      authors.each do |name|
        a = Author.find_or_create_by(name: name)
        BookAuthor.create(author: a, book: b)
      end
    end
    b.save!
  end

  #preferred method; has most important fields
  def self.google_api(isbn)
    url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
    req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'].to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = response.body
    temp_hash = JSON.parse(body)

    return nil if temp_hash["totalItems"] == 0

    book_hash = temp_hash["items"].first["volumeInfo"]

    google_info = Hash.new
    google_info["title"] = book_hash["title"]
    google_info["publisher"] = book_hash["publisher"]
    google_info["publish_date"] = book_hash["publishedDate"]
    google_info["language"] = book_hash["lang"]
    google_info["pages"] = book_hash["pageCount"]
    google_info["isbn"] = isbn
    google_info["authors"] = temp_hash["items"].first["volumeInfo"]["authors"]

    return google_info
  end

  def self.good_reads_api(isbn)
    url = URI.parse("https://www.goodreads.com/search.xml?key=#{ENV['good_reads_api_key']}=&q=#{isbn}")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = response.body
    temp_hash = Hash.from_xml(body)

    book_hash = temp_hash['GoodreadsResponse']['search']['results']['work']

    good_reads_info = Hash.new
    good_reads_info['publish_date'] = book_hash['original_publication_year']
    good_reads_info['title'] = book_hash['best_book']['title']
    good_reads_info['title'] = book_hash['best_book']['title']
    good_reads_info['authors'] = [book_hash['best_book']['author']['name']]
    
    return good_reads_info
  end

  def self.world_cat_api(isbn)
    url = URI.parse("http://xisbn.worldcat.org/webservices/xid/isbn/#{isbn}?method=getMetadata&format=json&fl=*")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    response = http.request(req)
    body = response.body
    book_hash = JSON.parse(body)["list"].first

    world_cat_info = Hash.new
    world_cat_info["title"] = book_hash["title"]
    world_cat_info["publisher"] = book_hash["publisher"]
    world_cat_info["language"] = book_hash["lang"]
    world_cat_info["publish_date"] = book_hash["year"]
    world_cat_info["publish_place"] = book_hash["city"]

    return world_cat_info
  end
end