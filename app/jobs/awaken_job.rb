class AwakenJob < RcxCommandJob

  AWAKEN_TIMEOUT = 600 #seconds

  def over?
    @invocation.client.listening? 
  end

  def on_finish
    ExecuteJob.perform_later(@invocation)
  end

  def start_work
    @invocation.client.awaken!
  end

  def perform(invocation, started_work=false, timeout=AWAKEN_TIMEOUT)
  	super(invocation, started_work, timeout)
  end
end
