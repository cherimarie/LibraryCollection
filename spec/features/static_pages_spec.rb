require 'spec_helper'

describe 'Static Pages', type: feature do 
  subject { page }

  describe 'Home Page' do 
    before { visit root_path }

    it 'has working genre link' do expect(subject).to have_link('by category', href: genres_path) end
    it 'has working author link' do expect(subject).to have_link('by author', href: authors_path) end
    it 'has working keyword link' do expect(subject).to have_link('by keyword', href: keywords_path) end
    it 'does not have admin links' do expect(subject).to_not have_link('dashboard') end
    it 'does not have logout links' do expect(subject).to_not have_link('logout') end
    it 'does not have profile links' do expect(subject).to_not have_link('edit profile') end

    describe 'Search' do

      context 'with no term' do
        before { click_on 'search' }
        it 'promts for term' do expect(subject).to have_content('Please enter a search term.') end
      end

      context 'with non-matching term' do
        before do 
          fill_in('search', :with => 'XXXXXXXXXXXX!XXX')
          click_on('search')
        end
        it 'flashes no results' do expect(subject).to have_content('Your search yielded no results.') end
      end

      context 'with matching term' do
        before do 
          @book = FactoryGirl.create(:book)
          fill_in('search', :with => @book.title)
          click_on('search')
        end
        it 'shows matches' do expect(subject).to have_content("Books: #{@book.title}") end
      end 
    end
  end

  describe 'Admin' do
    describe 'login' do
      context 'with invalid credentials' do
        before do
          visit root_path
          click_on('login')
          fill_in("Login", :with => 'bogus@email.com')
          fill_in("Password", :with => 'nope')
          click_on("sign in")
        end

        it "should flash invalid" do expect(subject).to have_content('Invalid login or password.') end
      end

      context 'valid credentials' do
        before do
            admin = FactoryGirl.create(:admin, password: "password", email: "email@email.com")
            visit root_path
            click_on('login')
            fill_in("Login", :with => admin.email)
            fill_in("Password", :with => 'password')
            click_on("sign in")
        end

        it "should flash success" do expect(subject).to have_content('Signed in successfully.') end
        it 'has admin links' do expect(subject).to have_link('dashboard') end
        it 'has logout links' do expect(subject).to have_link('logout') end
        it 'has profile links' do expect(subject).to have_link('my profile') end
      end

      context 'then logout' do
        before do
          admin_login
          visit root_path
          click_on 'logout'
        end

        it "should flash success" do expect(subject).to have_content('Signed out successfully.') end
        it 'does not have admin links' do expect(subject).to_not have_link('dashboard') end
        it 'does not have logout links' do expect(subject).to_not have_link('logout') end
        it 'does not have profile links' do expect(subject).to_not have_link('my profile') end
      end
    end

    describe 'Dashboard' do
      before do
          admin_login
          visit root_path
          click_on('dashboard')
      end

      after do
        Warden.test_reset!
      end

      describe 'links' do
        it 'has upload' do expect(subject).to have_link('Upload Books') end
        it 'has manage Books' do expect(subject).to have_link('Manage Books') end
        it 'has manage Genres' do expect(subject).to have_link('Manage Categories') end
        it 'has manage Authors' do expect(subject).to have_link('Manage Authors') end
        it 'has manage Keywords' do expect(subject).to have_link('Manage Keywords') end
        it 'has manage Users' do expect(subject).to have_link('Manage Users') end
        it 'has manage Loans' do expect(subject).to have_link('Manage Loans') end
      end
    end
  end

  describe 'Librarian' do

    context 'valid credentials' do
      before do
          admin = FactoryGirl.create(:admin, password: "password", email: "email@email.com")
          visit root_path
          click_on('login')
          fill_in("Login", :with => admin.email)
          fill_in("Password", :with => 'password')
          click_on("sign in")
      end

      it "should flash success" do expect(subject).to have_content('Signed in successfully.') end
      it 'has admin links' do expect(subject).to have_link('dashboard') end
      it 'has logout links' do expect(subject).to have_link('logout') end
      it 'has profile links' do expect(subject).to have_link('my profile') end
    end

    describe 'Dashboard Access' do
      before do
        librarian_login
        visit root_path
        click_on('dashboard')
      end

      after do
        Warden.test_reset!
      end

      describe 'links' do
        it 'no upload' do expect(subject).to_not have_link('Upload Books') end
        it 'no manage Books' do expect(subject).to_not have_link('Manage Books') end
        it 'no manage Genres' do expect(subject).to_not have_link('Manage Categories') end
        it 'no manage Authors' do expect(subject).to_not have_link('Manage Authors') end
        it 'has manage Keywords' do expect(subject).to have_link('Manage Keywords') end
        it 'has manage Users' do expect(subject).to have_link('Manage Users') end
        it 'has manage Loans' do expect(subject).to have_link('Manage Loans') end
      end
    end
  end
end 
