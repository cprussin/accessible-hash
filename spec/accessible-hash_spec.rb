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
			expect(subject.keys).to eq(%i(attr other nilattr))
		end

		it 'does not stack overflow on undefined call' do
			expect{subject.bla}.to raise_error(NoMethodError)
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
	end
end
