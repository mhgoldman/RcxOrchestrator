class BatchesController < ApplicationController
	def index
		@batches = current_user.batches.all
	end

	def show
		@batch = current_user.batches.find(params[:id])
	end

	def new
	end

	def create
	end
end
