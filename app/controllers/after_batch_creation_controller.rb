class AfterBatchCreationController < ApplicationController
	include Wicked::Wizard

	before_action :set_batch

	steps :select_clients, :select_commands, :finish

	def show
		case step
		when :select_clients
			@rcx_clients = current_user.rcx_clients
		when :select_commands
		end

		render_wizard
	end

	def update
		set_batch

		case step
		when :select_clients
			@batch.update(rcx_client_ids: params[:batch][:rcx_client_ids])
			render_wizard @batch		
		when :select_commands
			@batch.batch_commands.create(command_id: params[:command_id_for_new_batch_command])
			render_wizard
		when :finish
			if params[:start_batch]
				@batch.start
				redirect_to @batch
			else
				@batch.destroy
				redirect_to batches_path
			end
		end
	end

	def set_batch
		@batch = current_user.batches.find(params[:batch_id])		
		raise "Cannot edit batch that already started" if @batch.started?
	end
end
