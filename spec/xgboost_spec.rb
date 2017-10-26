RSpec.describe Xgboost do
  it "has a version number" do
    expect(Xgboost::VERSION).to eq('0.1.0')
  end

  it "can talk to C" do
    expect(Xgboost.this_is_c).to eq(42)
  end
end
