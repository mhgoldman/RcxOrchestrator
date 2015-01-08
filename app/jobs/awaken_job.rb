class AwakenJob < RcxCommandJob

  AWAKEN_TIMEOUT = 600 #seconds

  def over?
    @client_batch_command.rcx_client.listening? 
  end

  def on_finish
    ExecuteJob.perform_later(@client_batch_command)
  end

  def start_work
    @client_batch_command.rcx_client.awaken!
  end

  def perform(client_batch_command, started_work=false, timeout=AWAKEN_TIMEOUT)
  	super(client_batch_command, started_work, timeout)
  end
end
