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

	# Merge hashes, converting keys to symbols
	def merge(other)
		super(keys_to_symbols(other))
	end

	# Merge into this hash, again converting keys to symbols
	def merge!(other)
		super(keys_to_symbols(other))
	end

	# Returns the keys and methods (not including methods in this class)
	def keys
		super + self.class.keys
	end

	# Use hash access if the key exists because it can't be anywhere else;
	# otherwise the key doesn't exist so call the real method_missing
	def method_missing(method, *args, &block)
		has_key?(method) ? self[method] : super
	end

	# Allow objects to return list their public methods as class keys
	def self.keys
		instance_methods(false) - %i([] []= merge merge! keys method_missing)
	end

	private

	def keys_to_symbols(hash)
		hash.inject({}) do |hsh, (key, value)|
			hsh[key.to_sym] = value
			hsh
		end
	end
end
