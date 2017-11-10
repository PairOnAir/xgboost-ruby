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
      end
    end
  end
end
