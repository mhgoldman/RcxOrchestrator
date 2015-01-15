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
    self.class.set(wait: POLL_INTERVAL.seconds).perform_later(@invocation, @work_has_started, remaining_timeout_period)
  end

  def reschedulable?
    @invocation.exists? && !work_has_started? && !timed_out?
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

  def perform(invocation, work_has_started, timeout)
    begin
      @invocation = invocation
      @timeout = timeout
      @work_has_started = work_has_started

      logger.debug "#{self.class}: invocation=#{@invocation}, timeout=#{@timeout}"

      raise "Invocation does not exist" unless @invocation.exists?
        
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
          error = "#{ex.class} while performing #{self}: #{ex}\n#{ex.backtrace.join("\n")} This job #{reschedulable? ? 'will' : 'will not'} be rescheduled."
          logger.error error
          @invocation.append_error(error) rescue nil          
          if reschedulable?
            reschedule
          else
            @invocation.fatally_errored!
          end
      rescue
        # Swallow exceptions in exception handling so they don't bubble up to ÅctiveJob
      end
    end      
  end
end
