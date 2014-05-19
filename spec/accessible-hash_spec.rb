require "#{File.dirname(__FILE__)}/../lib/accessible-hash"

describe AccessibleHash do

	shared_examples_for 'an accessible hash' do
		shared_examples_for 'an accessible object' do
			it 'allows access using strings with []' do
				expect(subject[key.to_str]).to eq(value)
			end

			it 'allows access using symbols with []' do
				expect(subject[key.to_sym]).to eq(value)
			end

			it 'allows access using send' do
				expect(subject.send(key)).to eq(value)
			end
		end

		context 'with a normal value' do
			let(:key) {'attr'}
			let(:value) {'value'}

			it_behaves_like 'an accessible object'
		end

		context 'with a false value' do
			let(:key) {'other'}
			let(:value) {false}

			it_behaves_like 'an accessible object'
		end

		context 'with a nil value' do
			let(:key) {'nilattr'}
			let(:value) {nil}

			it_behaves_like 'an accessible object'
		end

		it 'lists all keys as symbols' do
			expect(subject.keys.length).to be(3)
			expect(subject.keys).to include(:attr)
			expect(subject.keys).to include(:other)
			expect(subject.keys).to include(:nilattr)
		end

		it 'raises NoMethodError on undefined call' do
			expect{subject.bla}.to raise_error(NoMethodError)
		end

		it 'raises NoMethodError on undefined call with arguments' do
			expect{subject.bla(:argument)}.to raise_error(NoMethodError)
		end

		it 'raises NoMethodError on undefined lookup' do
			expect{subject[:bla]}.to raise_error(NoMethodError)
		end

		it 'sets values using string keys with []=' do
			expect{subject[:bla]}.to raise_error(NoMethodError)
			subject['bla'] = 'value'
			expect(subject[:bla]).to eq('value')
		end

		it 'sets values using symbol keys with []=' do
			expect{subject[:bla]}.to raise_error(NoMethodError)
			subject[:bla] = 'value'
			expect(subject[:bla]).to eq('value')
		end

		shared_examples_for 'a merging AccessibleHash' do
			it 'merges generating a new AccessibleHash' do
				merged = subject.merge(hash)
				expect(merged).not_to be(subject)
				expect(merged.keys.length).to be(4)
				expect(merged.keys).to include(:attr)
				expect(merged.keys).to include(:other)
				expect(merged.keys).to include(:nilattr)
				expect(merged.keys).to include(:key)
			end

			it 'merges extending itself' do
				expect(subject.keys.length).to be(3)
				subject.merge!(hash)
				expect(subject.keys.length).to be(4)
				expect(subject.keys).to include(:attr)
				expect(subject.keys).to include(:other)
				expect(subject.keys).to include(:nilattr)
				expect(subject.keys).to include(:key)
			end
		end

		context 'with a Hash with symbol keys' do
			it_behaves_like 'a merging AccessibleHash' do
				let(:hash) {{key: 'value'}}
			end
		end

		context 'with a Hash with string keys' do
			it_behaves_like 'a merging AccessibleHash' do
				let(:hash) {{'key' => 'value'}}
			end
		end

		context 'with another AccessibleHash' do
			class AccessibleHashMergingDummy < AccessibleHash
				def key
					'value'
				end
			end

			it_behaves_like 'a merging AccessibleHash' do
				let(:hash) {AccessibleHashMergingDummy.new}
			end
		end
	end

	context 'with a string hash' do
		let(:subject) {AccessibleHash.new('attr' => 'value', 'other' => false, 'nilattr' => nil)}

		it_behaves_like 'an accessible hash'
	end

	context 'with a symbol hash' do
		let(:subject) {AccessibleHash.new(attr: 'value', other: false, nilattr: nil)}

		it_behaves_like 'an accessible hash'
	end

	context 'with a mixed, deep hash' do
		let(:hash) {AccessibleHash.new(attr: 'value', 'otherattr' => {value: 'innerhash'})}

		it 'generates a new deep accessible hash' do
			expect(hash.attr).to eq('value')
			expect(hash.otherattr).to be_a(AccessibleHash)
			expect(hash.otherattr.value).to eq('innerhash')
		end
	end

	context 'with an object' do
		class AccessibleHashDummy < AccessibleHash
			def attr
				'value'
			end

			def other
				false
			end

			def nilattr
				nil
			end
		end
		let (:subject) {AccessibleHashDummy.new}

		it_behaves_like 'an accessible hash'

		it 'lists all methods as keys when asking for class keys' do
			expect(AccessibleHashDummy.keys).to eq(%i(attr other nilattr))
		end
	end
end
