# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
genres = Genre.create([{ name: 'Whisker Grooming'  }, 
                       { name: 'Comfortable Positions'  }, 
                       { name: 'Ew, Gross'  }])

#temp storage for books with no genre
Genre.create(name: 'Unassigned')

authors = Author.create([{ name: 'Chairman Meow' }, 
                         { name: 'Fluffy Faulkner'}, 
                         { name: 'B. Author' }, 
                         { name: 'Boots McNally'}])

books = Book.create([{ title: 'Kittles and Bits', genre: genres[0] }, 
                     { title: 'I Am Who Am I?', genre: genres[1] },
                     { title: 'The Sound and the Furry', genre: genres[0] },
                     { title: 'Meowtains', genre: genres[2] }])

@int = 0

#assigns cute name books to cute name authors
authors.each do |a|
  a.books << books[(@int += 1) % books.count]
end

@int = 0

#a bunch of extra test books assigned to authors
(1..100).each do |i|
  authors[@int % authors.count].books << 
                          Book.create(title: "Test Book #{i}", 
                                      genre: genres[(@int += 1) % genres.count])
end

# an admin user 
u = User.new(
  email: "admin@example.com",
  password: 'password')
u.add_role :admin
u.save!(:validate => false)

# a librarian user 
u = User.new(
  email: "librarian@example.com",
  password: 'password')
u.save!(:validate => false)

