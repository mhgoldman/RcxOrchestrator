class ClientBatchCommandJob < ActiveJob::Base
  queue_as :rcx_commands

  AWAKEN_ITERATION_WAIT = 30.seconds
  MAX_AWAKEN_ITERATIONS = 20
  START_ITERATION_WAIT = 30.seconds
  MAX_START_ITERATIONS = 60

  def perform(client_batch_command, action='awaken', iteration=1)
    begin
      puts "*** ClientBatchCommandJob perform: ClientBatchCommand ID=#{client_batch_command.id}, Action=#{action}, Iteration=#{iteration}"
      rcx_client = client_batch_command.rcx_client

      case action
      when 'awaken'
        if iteration == 1
          rcx_client.awaken!
        elsif iteration >= MAX_AWAKEN_ITERATIONS
          raise "Awaken timed out for #{client_batch_command}"
        end

        if rcx_client.listening?
          ClientBatchCommandJob.perform_later(client_batch_command, 'start')
        else 
          ClientBatchCommandJob.set(wait: AWAKEN_ITERATION_WAIT).perform_later(client_batch_command, 'awaken', iteration+1)
        end        
      when 'start'
        if iteration == 1
          client_batch_command.start!
        elsif iteration >= MAX_START_ITERATIONS
          raise "Awaken timed out for #{client_batch_command}"
        end

        if client_batch_command.refresh_status.finished?
          if client_batch_command.succeeded?
            next_client_batch_command = client_batch_command.next_client_batch_command
            ClientBatchCommandJob.set.perform_later(next_client_batch_command, 'start') if next_client_batch_command
          else
            # if the current client_batch_command failed, don't continue...
          end
        else
          ClientBatchCommandJob.set(wait: START_ITERATION_WAIT).perform_later(client_batch_command, 'start', iteration+1)
        end
      end
    rescue StandardError => ex
      client_batch_command.error = "#{ex.class} while performing ClientBatchCommand #{self}: #{ex}\n#{ex.backtrace}"
      client_batch_command.save
      logger.error client_batch_command.error
    end
  end
end
