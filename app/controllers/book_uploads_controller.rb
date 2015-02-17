class BookUploadsController < ApplicationController
  include BookUploadsHelper
  include UserRoleHelper
  require 'csv'
  rescue_from BookUpload::InvalidFileError, with: :invalid_file
  rescue_from CSV::MalformedCSVError, with: :invalid_file
  before_filter :authenticate_user!
  before_filter :is_admin?


  def new
    @book_upload = BookUpload.new
    @genre = Genre.new
  end

  def create
     if BookUpload.import_requirements?(params)
      @book_upload = BookUpload.new(book_uploads_params)
      genre = Genre.find_by(name: params[:book_upload][:genre])
      if @new_books = @book_upload.save
        flash[:notice] = "Upload successful"
        redirect_to uploaded_books_path(new_books: @new_books.length)
      else
        flash[:error] = "Upload failed"
        redirect_to new_book_upload_path
      end
    else
      flash[:alert] = "Please select a file and category"
      redirect_to new_book_upload_path
    end
  end

  def uploaded_books
    @new_books = Book.last(params[:new_books].to_i)
  end

private

  def invalid_file(msg)
    flash[:error] = "Upload Unsuccessful: please upload a file with the correct file type and formatting."
    redirect_to :back
  end
end
