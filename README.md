LibraryCollection
=================

A public web interface for patrons to view and search a library collection.

Ruby 2.0.0

###After you pull from origin, run:
 - bundle install --without production
 - rake db:migrate
 - rake db:seed RAILS_ENV=development
 - rails server

 Note: We now have different seed files for the different environments, so that we're not seeding a ton of fake books on production, only what we need. Therefore, we must now specify the environment when running 'rake db:seed'

###To see test coverage via SimpleCov gem:
  - run all tests via 'rake'
  - in a browser, open LibraryCollection/coverage/index.html


#v1
###public user can:

 - view library info on homepage
 - browse collection by author
 - browse collection by genre/category
 - search collection by genre/category, author, or title
 - contact librarians

###admin can:

 - log in to view admin dashboard
 - upload a file (export from previous cataloguing system) of books to be entered into collection


#v2

###admin can:

 - manage collection with CRUD capabilities for all items
 - enter the ISBN of a new item and get details for it via scrape process


#v3 : Full library management app!

###public user can:

 - see if a book is available to check out

###patron can:

 - log in to view their borrowing history
 - put an available book on hold

###librarian can:

 - log in to view librarian dashboard
 - create patron accounts (for borrowing & using the app)
 - check books in/out to patrons
 - view borrowing history of collection items
 - view borrowing history of each patron
 - generate reports from borrowing data

###admin can:

 - create librarian accounts

#Licensing: The MIT License (MIT)

Copyright (c) 2014 Cheri Allen & Patrick Dent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

