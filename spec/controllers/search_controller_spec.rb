# spec/controllers/search_controller_spec.rb
require 'spec_helper' 

describe SearchController do

  describe '#search' do 

    it 'returns results for good search terms' do 
      author = FactoryGirl.build(:author)
      get :search, "search" => "Kitty"
      response.should be_ok
      expect(assigns[:authors]).to_not be_nil
    end 

    it 'returns nothing for unsuccessful searches' do 
      get :search, search: "Pegasus"
      response.should be_ok
      assigns[:authors].first.should be nil
    end 

    it 'redirects with notice for nil search terms' do 
      get :search, search: ""
      flash[:notice].should_not be_nil
      response.should redirect_to root_url
    end 

  end 
end 