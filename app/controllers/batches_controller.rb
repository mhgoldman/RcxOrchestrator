class BatchesController < ApplicationController
	helper_method :can_create_batch?
	
	def index
		@batches = current_user.batches.started.order("id DESC")
	end

	def show
		@batch = current_user.batches.started.find(params[:id])
	end

	def new
		raise 'No clients and/or commands available' unless can_create_batch?

		@batch = Batch.new
	end

	def create
		@batch = current_user.batches.new(batch_params)

		if @batch.save
			redirect_to batch_after_batch_creation_path(@batch.id, :select_clients)
		else
			render 'new'
		end
	end


	def can_create_batch?
		current_user.clients.any? && Command.any?
	end

	private

	def batch_params
		params.require(:batch).permit(:name)
	end
end
