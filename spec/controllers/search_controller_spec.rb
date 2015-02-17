# spec/controllers/search_controller_spec.rb
require 'spec_helper'
require 'support/api_utilities'

describe SearchController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @librarian = create :librarian
  end 

  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end

  after do 
    DatabaseCleaner.clean
  end 

  after :each do 
    Warden.test_reset! 
  end 

  describe '#search' do

    before { sign_in @librarian }

    context 'as librarian' do
      it 'returns results for user terms' do
        get :search, "search" => @user.name
        response.should be_ok
        expect(assigns[:users]).to include(@user)
      end
    end

    it 'does not return results for user search terms' do
      get :search, "search" => @user.name
      response.should be_ok
      expect(assigns).to_not include(:user)
    end

    it 'returns results for good search terms' do
      keyword = FactoryGirl.create(:keyword)
      get :search, "search" => "boogers"
      response.should be_ok
      expect(assigns[:keywords]).to include(keyword)
    end

    it 'returns results for good, multi-word search terms' do
      book = FactoryGirl.create(:book, title: "The True Story of Those Boots")
      get :search, "search" => "True Boots"
      response.should be_ok
      expect(assigns[:books]).to include(book)
    end

    it 'returns nothing for unsuccessful searches' do
      get :search, search: "Pegasus"
      response.should be_ok
      expect(assigns[:authors].empty?).to be_true
    end

    it 'redirects with alert for nil search terms' do
      get :search, search: ""
      flash[:alert].should_not be_nil
      response.should redirect_to root_url
    end

  end

  describe 'scrape' do

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @admin = create :admin
    @isbn = "1234567890"
    @bad_input = "1234567890 1-2"
    create_google_stub(create_google_url(@isbn), "exists")
  end

  after do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end


    context 'as non-admin' do

      before { sign_in @user }


      it 'redirects un-authorized users' do
        expect(get :import).to redirect_to(root_path)
        expect(post :scrape, isbn: @isbn).to redirect_to(root_path)
      end
    end

    context 'as admin' do

      before { sign_in @admin }

      describe 'validations' do
        it 'for isbn 10' do
          post :scrape, isbn: @bad_input
          expect(response).to redirect_to(import_path)
        end
      end

      context 'success' do
        it 'redirects to edit book' do
          post :scrape, isbn: @isbn
          expect(response).to redirect_to(edit_book_path(Book.last))
        end
      end

      context 'failure' do
        it 'redirects to import' do
          Search.scrape(@isbn)
          post :scrape, isbn: @isbn
          expect(response).to redirect_to(import_path)
        end
      end
    end
  end
end
