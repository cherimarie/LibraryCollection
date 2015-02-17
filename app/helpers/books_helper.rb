module BooksHelper
  def book_params
    params.require(:book).permit(:id, :location, :title, :genre_id, author_ids: [], keyword_ids: [])
  end
end
