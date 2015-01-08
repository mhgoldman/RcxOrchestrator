class RcxCommandJob < ActiveJob::Base
  queue_as :rcx_commands

  POLL_INTERVAL = 30 #seconds

  def over?(client_batch_command, started_work, timeout)
    raise 'Not implemented'
  end

  def client_batch_command_should_be_started?(client_batch_command, started_work, timeout)
    raise 'Not implemented'
  end

  def on_finish(client_batch_command, started_work, timeout)
    raise 'Not implemented'
  end

  def start_work(client_batch_command, started_work, timeout)
    raise 'Not implemented'
  end

  def perform(client_batch_command, started_work, timeout)
    begin
      logger.debug "#{self.class}: client_batch_command=#{client_batch_command}, timeout=#{timeout}"
      puts "#{self.class}: client_batch_command=#{client_batch_command}, timeout=#{timeout}" #TODO remove me

      should_be_started = client_batch_command_should_be_started?(client_batch_command, started_work, timeout)
      if client_batch_command.started? != should_be_started
        raise "ClientBatchCommand #{client_batch_command.started? ? 'is' : 'is not'} started but #{should_be_started ? 'should' : 'should not'} be"
      end

      (start_work(client_batch_command, started_work, timeout) && started_work = true) unless started_work

      if over?(client_batch_command, started_work, timeout)
        on_finish(client_batch_command, started_work, timeout)
      elsif timeout - POLL_INTERVAL <= 0
        raise "#{self} timed out" 
      else
        self.class.set(wait: POLL_INTERVAL.seconds).perform_later(client_batch_command, started_work, timeout - POLL_INTERVAL)
      end
    rescue StandardError => ex
      client_batch_command.error = "#{ex.class} while performing #{self}: #{ex}\n#{ex.backtrace}"
      client_batch_command.save
      logger.error client_batch_command.error
    end      
  end
end
