require 'rails_helper'

RSpec.describe RcxSkytap::SkytapClient, :type => :model do
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

	context ".awaken" do
		it "awakens the VM" do
			VCR.use_cassette("awaken_skytap_vm") do
				client = RcxSkytap::SkytapClient.fetch_for_user(u).first
				skytap_vm = client.get_skytap_vm

				if VCR.current_cassette.recording? && skytap_vm.runstate == 'running'
					skytap_vm.runstate = 'suspended'
					skytap_vm.save
				end

				expect(skytap_vm.runstate).to eq 'suspended'

				client.awaken!
				sleep 60 if VCR.current_cassette.recording?

				skytap_vm = client.get_skytap_vm
				expect(skytap_vm.runstate).to eq 'running'
			end
		end
	end

	

	# context ".fetch_for_user(user)" do
	# 	it "gets skytap VMs for user" do
	# 		VCR.use_cassette("fetched_skytap_vms") do
	# 			clients_for_user = RcxSkytap::SkytapClient.fetch_for_user(u)
	# 			expect(clients_for_user.count).to eq 2
	# 		end

	# 		VCR.use_cassette("fetched_skytap_vm_details") do
	# 			clients_for_user = RcxSkytap::SkytapClient.fetch_for_user(u)
	# 			skytap_vm = clients_for_user.first.get_skytap_vm
	# 			expect(skytap_vm.runstate).to eq 'stopped'
	# 			expect(skytap_vm.id).to eq '4524114'
	# 			expect(skytap_vm.name).to eq 'Sharepoint Server 2013 Trial - Windows Server 2012 Standard - Eval'
	# 			expect(skytap_vm.configuration_url).to eq 'https://cloud.skytap.com/configurations/3287576'
	# 		end
	# 	end
	# end
end
