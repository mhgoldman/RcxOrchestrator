class AwakenJob < RcxCommandJob

  AWAKEN_TIMEOUT = 600 #seconds

  def finished?(client_batch_command, started_work, timeout)
    client_batch_command.rcx_client.listening?
  end

  def client_batch_command_should_be_started?(client_batch_command, started_work, timeout)
    false
  end

  def on_finish(client_batch_command, started_work, timeout)
    ExecuteJob.perform_later(client_batch_command)
  end

  def start_work(client_batch_command, started_work, timeout)
    client_batch_command.rcx_client.awaken!
  end

  def perform(client_batch_command, started_work=false, timeout=AWAKEN_TIMEOUT)
  	super(client_batch_command, started_work, timeout)
  end
end
