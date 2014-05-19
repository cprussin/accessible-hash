# This class provides a more accessible hash that can be used either like a
# HashWithIndifferentAccess or like an object.  Internally it converts all keys
# to symbols and utilizes method_missing to fall back on class methods.
class AccessibleHash < Hash

	# Creates a new AccessibleHash.
	#
	# @param fields [Hash] the fields to initialize when creating the object
	def initialize(fields = {})
		self.merge!(fields.inject({}) do |hsh, (key, value)|
			if value.is_a? Hash
				hsh[key] = AccessibleHash.new(value)
			else
				hsh[key] = value
			end
			hsh
		end)
	end

	# Retrieves the requested value from the object.
	#
	# @param elem [String, Symbol] the element to retrieve from the object
	# @return the value with the given key, or the method with the given name
	# @raise [NoMethodError] if the key does not reference one that the object
	#   has a value for or a class method for the object
	def [](elem)
		has_key?(e = elem.to_sym) ? super(e) : send(e)
	end

	# Sets a value on the object.
	#
	# @param elem [String, Symbol] the key to set on the object
	# @param value the value to set for the given key
	def []=(elem, value)
		super(elem.to_sym, value)
	end

	# Merges two hashes, converting keys to symbols, and returns the new hash.
	#
	# @param other [Hash] the hash to merge with this
	# @return [AccessibleHash] the new object, composed of the keys of the two
	#   merged objects
	def merge(other)
		super(keys_to_symbols(other))
	end

	# Merges a given hash into this object, converting all keys to symbols.
	#
	# @param other [Hash] the hash to merge into this
	def merge!(other)
		super(keys_to_symbols(other))
	end

	# Returns the keys and methods of the object.
	#
	# @return [Array<Symbol>] a list of all keys for this object
	def keys
		super + self.class.keys
	end

	# If the method exists, looks it up in the hash; otherwise, raises a
	# NoMethodError.
	#
	# @param method [Symbol] the name of the attribute/method being looked up
	# @return the value with the given method name as the key
	# @raise [NoMethodError] if no such key exists
	def method_missing(method, *args)
		has_key?(method) ? self[method] : super
	end

	# Returns the methods defined in a subclass of AccessibleHash, which are keys
	# of any instance of that class.
	#
	# @return [Array<Symbol>] a list of methods for the class
	def self.keys
		instance_methods(false) - %i([] []= merge merge! keys method_missing)
	end

	private

	# Converts all keys of the given hash to symbols and returns a new Hash.
	#
	# @param hash [Hash] the hash whose keys need converting
	# @return [Hash] the converted hash with all symbol keys
	def keys_to_symbols(hash)
		hash.keys.inject({}) do |hsh, key|
			hsh[key.to_sym] = hash[key]
			hsh
		end
	end
end
