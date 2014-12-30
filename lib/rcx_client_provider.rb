class RcxClientProvider
	cattr_reader :user_settings, :display_name

	def initialize
		raise "#{self.class} cannot be instantiated"
	end

	def self.get_clients
		raise 'Not implemented'
	end

	private

	def self.uses_user_setting(*args)
		instance_eval do
			@@user_settings ||= []
			@@user_settings |= args
		end
	end

	def self.has_display_name(name)
		instance_eval { @@display_name = name }
	end
end
