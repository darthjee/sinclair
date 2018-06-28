require 'spec_helper' 

describe 'matchers' do
  describe 'add_method_to' do
    let(:method)   { :the_method }
    let(:klass)    { Class.new }
    let(:instance) { klass.new }

    context 'when method is added' do
      it do
        expect do
          klass.send(:define_method, method) {}
        end.to add_method(method).to(instance)
      end
    end

    context 'when method is not added' do
      it do
        expect do
          expect do
            1
          end.to add_method(method).to(instance)
        end.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          "expected 'the_method' to be added to #{klass} but it didn't"
        )
      end
    end
  end
end
