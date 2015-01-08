class ExecuteJob < RcxCommandJob
  
  EXECUTE_TIMEOUT = 1800 #seconds

  def over?(client_batch_command, started_work, timeout)
    client_batch_command.refresh_status.over?
  end

  def client_batch_command_should_be_started?(client_batch_command, started_work, timeout)
    started_work
  end

  def on_finish(client_batch_command, started_work, timeout)
    if client_batch_command.succeeded?
      next_client_batch_command = client_batch_command.next_client_batch_command
      ExecuteJob.set.perform_later(next_client_batch_command) if next_client_batch_command
    else
      raise "ClientBatchCommand #{client_batch_command} failed, aborting batch for client #{rcx_client}"
    end
  end

  def start_work(client_batch_command, started_work, timeout)
    client_batch_command.start!
  end

  def perform(client_batch_command, started_work=false, timeout=EXECUTE_TIMEOUT)
    super(client_batch_command, started_work, timeout)
  end
end