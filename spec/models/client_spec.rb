require 'rails_helper'

RSpec.describe Client, :type => :model do
	VCR.configure do |config|
	  config.cassette_library_dir = "spec/vcr_cassettes"
	  config.hook_into :webmock # or :fakeweb
	end

	u = User.new(email: 'me@mgoldman.com', 
		password: 'foobarbaz', 
		password_confirmation: 'foobarbaz',
		rcx_skytap_username: 'martin@mgoldman.com',
		rcx_skytap_api_token: 'TESTPASSWORD'
	)
	u.skip_confirmation!
	u.save!

	client = HardcodedClient.fetch_for_user(u).first

	context "#listening?" do
		it "is listening" do
			VCR.use_cassette("is_listening") do
				expect(client.listening?).to eq true
			end
		end
	end
end
