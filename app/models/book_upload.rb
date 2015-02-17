class BookUpload < ActiveRecord::Base

  include Uploadable

  def make_object(book_data)
    return false if book_data["title"] == false

    if (book = Book.find_by_isbn(book_data["isbn"]))
      book.count += 1
      book.update_availability
      return
    end

    book = Book.create( title:  book_data["title"],
                        genre:  Genre.find_by_name(genre),
                        publisher: book_data["publisher"],
                        publish_date:  book_data["publish date"],
                        isbn: book_data["isbn"])
    
    @new_objects << book.id

    if book_data["author"]
      make_authors(book_data["author"]).each do |auth| 
        BookAuthor.create(book: book, author: auth)
      end
    end
  end

  def make_authors(names)
    names.split(';').map! { |name| Author.find_or_create_by(name: name) }
  end
  
  def self.import_requirements?(params)
    if params[:book_upload].has_key?(:file) && !params[:book_upload][:genre].blank?
      true
    else
      false
    end
  end
end

