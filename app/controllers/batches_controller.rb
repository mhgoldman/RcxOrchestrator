class BatchesController < ApplicationController
	def index
		@batches = current_user.batches.started.order("id DESC")
	end

	def show
		@batch = current_user.batches.started.find(params[:id])
	end

	def new
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

	def batch_params
		params.require(:batch).permit(:name)
	end
end
