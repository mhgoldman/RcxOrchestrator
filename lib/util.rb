class Util
	def self.over?(collection)
		collection.each {|cbc| return false unless cbc.over? }
		true
	end
end		