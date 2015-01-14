class AwakenJob < RcxCommandJob

  AWAKEN_TIMEOUT = 600 #seconds

  def over?
    @client_step.client.listening? 
  end

  def on_finish
    ExecuteJob.perform_later(@client_step)
  end

  def start_work
    @client_step.client.awaken!
  end

  def perform(client_step, started_work=false, timeout=AWAKEN_TIMEOUT)
  	super(client_step, started_work, timeout)
  end
end
