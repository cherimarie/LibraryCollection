require 'spec_helper'

describe 'User Pages', type: feature do
  let!(:user) { create(:user) }

  describe 'index' do
    it 'displays "patron" as role of user with no role' do
      admin_login
      visit users_path
      expect(page).to have_content("patron")
      expect(page.all('table tbody tr').count).to eq(User.all.length)
    end
  end

  describe 'sign up' do
    context 'with good info' do
      before do
        visit root_path
        click_on 'create an account'
        fill_in('Email', with: 'imatestemail@test.com')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')
        fill_in('Full Legal Name', with: 'Grimpy Grue')
        fill_in('Mailing Address', with: '123 Here ave, Seattle WA 98122')
        fill_in('Phone', with: '55555555555')
        fill_in('Preferred first name', with: 'Smelvin')
        click_on 'sign up'
      end

      it 'flashes success' do expect(page).to have_content('Welcome! You have signed up successfully.') end
    end
  end
end