class RcxCommandJob < ActiveJob::Base
  queue_as :rcx_commands

  POLL_INTERVAL = 30 #seconds

  def timed_out?
    remaining_timeout_period <= 0
  end

  def remaining_timeout_period
    @timeout - POLL_INTERVAL
  end

  def reschedule
    self.class.set(wait: POLL_INTERVAL.seconds).perform_later(@client_step, @work_has_started, remaining_timeout_period)
  end

  def reschedulable?
    @client_step.exists? && !work_has_started? && !timed_out?
  end

  def work_has_started?
    @work_has_started
  end
  
  def over?
    raise 'Not implemented'
  end

  def on_finish
    raise 'Not implemented'
  end

  def start_work
    raise 'Not implemented'
  end

  def perform(client_step, work_has_started, timeout)
    begin
      @client_step = client_step
      @timeout = timeout
      @work_has_started = work_has_started

      logger.debug "#{self.class}: client_step=#{@client_step}, timeout=#{@timeout}"

      raise "ClientStep does not exist" unless @client_step.exists?
        
      (start_work && @work_has_started = true) unless @work_has_started

      if over?
        on_finish
      elsif timed_out?
        raise "#{self} timed out" 
      else
        reschedule
      end
    rescue StandardError => ex
      begin
          error = "#{ex.class} while performing #{self}: #{ex}\n#{ex.backtrace.join("\n")} This job is #{reschedulable? ? 'will' : 'will not'} be rescheduled."
          logger.error error
          @client_step.append_error(error) rescue nil          
          if reschedulable?
            reschedule
          else
            @client_step.fatally_errored!
          end
      rescue
        # Swallow exceptions in exception handling so they don't bubble up to ÅctiveJob
      end
    end      
  end
end
