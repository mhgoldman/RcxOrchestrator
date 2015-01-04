class StepInstanceJob < ActiveJob::Base
  queue_as :rcx_commands

  def perform(step_instance)
  	step_instance.refresh_status if step_instance.started?

    if step_instance.finished?
      if step_instance.succeeded?
      	next_step_instance = step_instance.next_step_instance
        StepInstanceJob.set.perform_later(next_step_instance) if next_step_instance
      else
      	# don't continue the batch for this client...
      end
    else
      step_instance.start! unless step_instance.started?
      StepInstanceJob.set(wait: 30.seconds).perform_later(step_instance)
    end
  end
end
