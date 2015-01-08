class RcxCommandJob < ActiveJob::Base
  queue_as :rcx_commands

  POLL_INTERVAL = 30 #seconds

  def timed_out?
    remaining_timeout_period <= 0
  end

  def remaining_timeout_period
    @timeout - POLL_INTERVAL
  end

  def over?
    raise 'Not implemented'
  end

  def client_batch_command_should_be_started?
    raise 'Not implemented'
  end

  def on_finish
    raise 'Not implemented'
  end

  def start_work
    raise 'Not implemented'
  end

  def perform(client_batch_command, work_previously_started, timeout)
    begin
      @client_batch_command = client_batch_command
      @timeout = timeout

      logger.debug "#{self.class}: client_batch_command=#{@client_batch_command}, timeout=#{@timeout}"

      unless ClientBatchCommand.exists?(@client_batch_command.id)
        raise "ClientBatchCommand #{@client_batch_command.id} no longer exists - I may be a duplicate job"
      end

      start_work unless work_previously_started

      if over?
        on_finish
      elsif timed_out?
        raise "#{self} timed out" 
      else
        self.class.set(wait: POLL_INTERVAL.seconds).perform_later(@client_batch_command, true, remaining_timeout_period)
      end
    rescue StandardError => ex
      begin
        error = "#{ex.class} while performing #{self}: #{ex}\n#{ex.backtrace.join("\n")}"
        logger.error error
        @client_batch_command.update(error: error)
      rescue
        # Swallow exceptions in exception handling so they don't bubble up to ÅctiveJob
      end
    end      
  end
end
