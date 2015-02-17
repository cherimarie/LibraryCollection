require 'spec_helper'

describe BookUploadsController do

  let(:good_file) { fixture_file_upload('files/book_uploads_good_file.txt', 'text/xml') }
  let(:bad_file) { fixture_file_upload('files/book_uploads_bad_file.txt', 'text/xml') }

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @admin = create :admin
  end

  after do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end

  describe 'as non-admin' do

    before { sign_in @user }

    it 'redirects unauthorized users' do
      expect(get :new).to redirect_to(root_path)
      expect(post :create).to redirect_to(root_path)
      expect(get :uploaded_books).to redirect_to(root_path)
    end
  end

  describe 'as admin' do

    before { sign_in @admin }

    context 'without import requirements' do

      it 'redirects to new upload' do
        post :create, book_upload: { genre: nil, file: nil }
        expect(response).to redirect_to(new_book_upload_path)
      end

      it 'flashes error' do
        post :create, book_upload: { genre: nil, file: nil }
        expect(flash[:alert]).to eq "Please select a file and category"
      end
    end

    context 'with bad file' do

      before(:each) do
        request.env["HTTP_REFERER"] = new_book_upload_path
      end

      it 'redirects back' do
        post :create, book_upload: { genre: create(:genre), file: bad_file }
        expect(response).to redirect_to(new_book_upload_path)
      end

      it 'flashes error' do
        post :create, book_upload: { genre: create(:genre), file: bad_file }
        expect(flash[:error]).to eq "Upload Unsuccessful: please upload a file with the correct file type and formatting."
      end
    end

    context 'with good file' do

      it 'redirects to uploaded books' do
        post :create, book_upload: { genre: create(:genre), file: good_file }
        expect(response).to redirect_to('/uploaded_books?new_books=20')
      end

      it 'flashes success' do
        post :create, book_upload: { genre: create(:genre), file: good_file }
        expect(flash[:notice]).to eq "Upload successful"
      end
    end
  end
end