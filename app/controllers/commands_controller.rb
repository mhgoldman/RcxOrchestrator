class CommandsController < ApplicationController
	before_action :set_command, only: [:edit, :update, :destroy, :show]	

	def new
		@command = Command.new
	end

	def create
		@command = Command.new(command_params)
		if @command.save
			flash[:notice] = 'Your command was created'
			redirect_to @command
		else
			render 'new'
		end
	end
	

	def edit
	end

	def update
		if @command.update(command_params)
			flash[:notice] = 'Your command was updated'
			redirect_to @command
		else
			render 'edit'
		end		
	end

	def destroy
		@command.destroy
				
		flash[:notice] = 'Your command was deleted'
		redirect_to commands_path	
	end

	def show
	end

	def index
		@commands = Command.all
	end

	private

	def command_params
		params.require(:command).permit(:name, :description, :path, :args)
	end

	def set_command
		@command = Command.find(params[:id])
	end
end
