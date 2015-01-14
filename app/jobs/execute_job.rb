class ExecuteJob < RcxCommandJob
  
  EXECUTE_TIMEOUT = 1800 #seconds

  def over?
    @client_step.refresh_status.over?
  end

  def on_finish
    if @client_step.succeeded?
      next_step = @client_step.next
      ExecuteJob.set.perform_later(next_step) if next_step
    else
      raise "ClientStep #{@client_step} errored/failed, aborting batch for client #{client}"
    end
  end

  def start_work
    @client_step.start!
  end

  def perform(client_step, started_work=false, timeout=EXECUTE_TIMEOUT)
    super(client_step, started_work, timeout)
  end
end