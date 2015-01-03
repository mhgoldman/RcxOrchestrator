require 'rails_helper'

RSpec.describe CommandsController, :type => :controller do
	before do
		@user = create(:user)
		@command = create(:command)
	end

	describe 'GET index' do
		it "lists commands if logged in" do
			sign_in(@user)

			get :index
			expect(response).to render_template :index
			expect(assigns(:commands)).to eq ([@command])
		end

		it "redirects if not logged in" do
			get :index
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	describe 'DELETE' do
		it "doesn't allow deletion when not signed in" do
			delete :destroy, id: @command.id
			expect(response).to redirect_to(new_user_session_path)
		end

		it "allows deletion when signed in" do
			sign_in(@user)
			delete :destroy, id: @command.id
			expect(Command.count).to eq 0
			expect(response).to redirect_to(commands_path)
		end
	end
end
