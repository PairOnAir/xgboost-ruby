RSpec.describe Xgboost::Booster do
  it 'saves and loads' do
    require 'tempfile'
    file = Tempfile.new
    orig = Xgboost::Booster.new
    orig.save(file.path)
    copy = Xgboost::Booster.new

    expect { copy.load(file.path) }.not_to raise_error
  end
end
