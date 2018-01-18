RSpec.describe Xgboost::Booster do
  it 'saves and loads' do
    require 'tempfile'
    file = Tempfile.new
    orig = Xgboost::Booster.new
    orig.save(file.path)
    copy = Xgboost::Booster.new

    expect { copy.load(file.path) }.not_to raise_error
  end

  describe '#predict' do
    context 'when passed a one dimensional array' do
      let(:booster) do
        booster = Xgboost::Booster.new
        booster.load(File.join(File.dirname(__FILE__), '../fixtures/linear.model'))
        booster
      end

      it 'returns a single prediction for that one example' do
        expect(booster.predict([2.0])).to be_within(0.00001).of(4.03468)
        expect(booster.predict([1.0])).to be_within(0.00001).of(2.06937)
      end

      it 'raises an error when given invalid arguments' do
        expect { booster.predict(2.0) }.to raise_error(TypeError)
        expect { booster.predict(nil) }.to raise_error(TypeError)
      end

      it 'returns an array of prediction for an array of examples' do
        input = [[2.0], [2.0], [1.0], [3.0]]
        expected = [4.03468, 4.03468, 2.06937, 6.0]

        actual = booster.predict(input)

        expect(actual.count).to eq(expected.count)

        actual.each_with_index do |a, i|
          expect(a).to be_within(0.00001).of(expected[i])
        end
      end
    end
  end
end
