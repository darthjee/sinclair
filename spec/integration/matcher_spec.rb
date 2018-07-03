require 'spec_helper'

describe 'matchers' do
  describe 'add_method_to' do
    let(:method)   { :the_method }
    let(:klass)    { Class.new }
    let(:instance) { klass.new }
    let(:expectation) do
      expect { block.call }.to add_method(method).to(instance)
    end
    let(:block) { Proc.new { klass.send(:define_method, method) {} } }


    context 'when method is added' do
      it 'returns a succes' do
        expect { expectation }.not_to raise_error
      end
    end

    context 'when method is not added' do
      let(:block) { Proc.new {} }

      it 'raises expectation error' do
        expect { expectation }.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          "expected 'the_method' to be added to #{klass} but it didn't"
        )
      end
    end

    context 'when method existed before' do
      before do
        block.call
      end
      it 'raises expectation error' do
        expect { expectation }.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          "expected 'the_method' to be added to #{klass} but it already existed"
        )
      end
    end

    context "when negating" do
      let(:expectation) do
        expect { block.call }.not_to add_method(method).to(instance)
      end

      context 'when method is not added' do
        let(:block) { Proc.new {} }

        it 'returns a succes' do
          expect { expectation }.not_to raise_error
        end
      end

      context 'when method is added' do
        it 'raises expectation error' do
          expect { expectation }.to raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            "expected 'the_method' not to be added to #{klass} but it was"
          )
        end
      end

      context 'when method existed before' do
        before do
          block.call
        end

        it 'returns a succes' do
          expect { expectation }.not_to raise_error
        end
      end
    end
  end
end
