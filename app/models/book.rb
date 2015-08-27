class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_keywords
  has_many :keywords, through: :book_keywords
  has_many :contributions, through: :book_authors
  has_many :loans, dependent: :restrict_with_error
  has_many :users, through: :loans

  scope :available_to_loan, -> { where(available: true ) }

  validates :title, presence: true

  def self.search(search)
    search_length = search.split.length
    where([(['lower(title) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }) +
    where([(['isbn LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }) +
    where([(['lower(location) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:title)
  end

  def update_availability
    if self.count <= self.loans.active.count || self.missing
      update_attribute(:available, false)
    elsif self.count > self.loans.active.count
      update_attribute(:available, true)
    end
  end

  def selected?(selected_books)
    if selected_books && selected_books.include?(self.id)
      return true
    else
      return false
    end
  end

  def primary_author
    return nil if authors.empty?

    alpha_author = authors.first

    book_authors.each do |b|
      return Author.find_by(id: b.author_id) if b.primary
      author = Author.find_by(id: b.author_id)
      return nil unless author
      alpha_author = author if author.sort_by < alpha_author.sort_by
    end
    return alpha_author
  end

  def other_contributors(primary)
    authors.reject { |a| a == primary }
  end
end
