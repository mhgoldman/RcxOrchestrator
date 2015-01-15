class ExecuteJob < RcxCommandJob
  
  EXECUTE_TIMEOUT = 1800 #seconds

  def over?
    @invocation.refresh_status.over?
  end

  def on_finish
    if @invocation.succeeded?
      next_step = @invocation.next
      ExecuteJob.set.perform_later(next_step) if next_step
    else
      raise "Invocation #{@invocation} errored/failed, aborting batch for client #{client}"
    end
  end

  def start_work
    @invocation.start!
  end

  def perform(invocation, started_work=false, timeout=EXECUTE_TIMEOUT)
    super(invocation, started_work, timeout)
  end
end