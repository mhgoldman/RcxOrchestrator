class StepInstanceJob < ActiveJob::Base
  queue_as :rcx_commands

  AWAKEN_ITERATION_WAIT = 30.seconds
  MAX_AWAKEN_ITERATIONS = 4
  START_ITERATION_WAIT = 30.seconds
  MAX_START_ITERATIONS = 60

  def perform(step_instance, action='awaken', iteration=1)
    puts "*** StepInstanceJob perform: StepInstance ID=#{step_instance.id}, Action=#{action}, Iteration=#{iteration}"
    rcx_client = step_instance.rcx_client

    case action
    when 'awaken'
      if iteration == 1
        rcx_client.awaken!
      elsif iteration >= MAX_AWAKEN_ITERATIONS
        raise "Awaken timed out for #{step_instance}"
      end

      if rcx_client.listening?
        StepInstanceJob.perform_later(step_instance, 'start')
      else 
        StepInstanceJob.set(wait: AWAKEN_ITERATION_WAIT).perform_later(step_instance, 'awaken', iteration+1)
      end        
    when 'start'
      if iteration == 1
        step_instance.start!
      elsif iteration >= MAX_START_ITERATIONS
        raise "Awaken timed out for #{step_instance}"
      end

      if step_instance.refresh_status.finished?
        if step_instance.succeeded?
          next_step_instance = step_instance.next_step_instance
          StepInstanceJob.set.perform_later(next_step_instance, 'start') if next_step_instance
        else
          # if the current step_instance failed, don't continue...
        end
      else
        StepInstanceJob.set(wait: START_ITERATION_WAIT).perform_later(step_instance, 'start', iteration+1)
      end
    end
  end
end
