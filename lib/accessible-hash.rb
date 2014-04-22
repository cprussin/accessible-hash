# This class provides a more accessible hash that can be used either like a
# HashWithIndifferentAccess or like an object.
class AccessibleHash < Hash

	# Include the fields passed into new when instantiating
	def initialize(fields = {})
		self.merge!(fields)
	end

	# Get a value using hash access if the value exists; otherwise, try using
	# object access
	def [](elem)
		has_key?(e = elem.to_sym) ? super(e) : send(e)
	end

	# Set a value, but convert all keys to symbols
	def []=(elem)
		super(elem.to_sym)
	end

	# Merge hashes, again converting keys to symbols
	['', '!'].each do |bang|
		define_method "merge#{bang}" do |other|
			super(other.inject({}) do |hash, (key, value)|
				hash[key.to_sym] = value
				hash
			end)
		end
	end

	# Returns the keys and methods (not including methods in this class)
	def keys
		super + public_methods(false) - %i([] []= merge merge! keys method_missing)
	end

	# Use hash access if the key exists because it can't be anywhere else;
	# otherwise the key doesn't exist so call the real method_missing
	def method_missing(method, *args, &block)
		has_key?(method) ? self[method] : super
	end

	# Allow objects to return list their public methods as class keys
	def self.keys
		new.keys
	end
end
