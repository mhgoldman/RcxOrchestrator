require 'rails_helper'

feature 'User registration' do

	before do
		ActionMailer::Base.deliveries.clear
	end

	scenario 'User registers successfully' do
		visit new_user_registration_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		fill_in 'Password confirmation', with: 'somepa$$word1'
		click_button 'Sign Up'
		expect(page).to have_content('A message with a confirmation link has been sent to your email address')
		
		open_email('me@mgoldman.com')
		click_first_link_in_email
		expect(page).to have_content('Your email address has been successfully confirmed')

		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log In'
		expect(page).to have_content('Signed in successfully')		
	end
end	