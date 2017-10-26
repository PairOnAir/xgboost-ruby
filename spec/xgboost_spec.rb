RSpec.describe Xgboost do
  it "has a version number" do
    expect(Xgboost::VERSION).to eq('0.1.0')
  end

  it "can talk to C" do
    expect(Xgboost.this_is_c).to eq(42)
  end

  it "can add two numbers in C" do
    expect(Xgboost.add_in_c(20, 22)).to eq(42)
  end

  it "can add other two numbers in C" do
    expect(Xgboost.add_in_c(1, 2)).to eq(3)
  end

  it "only accepts numeric inputs" do
    expect { Xgboost.add_in_c("foo", 2) }.to raise_error(ArgumentError, "Argument 1 has to be of type Fixnum")
    expect { Xgboost.add_in_c(2, nil) }.to raise_error(ArgumentError, "Argument 2 has to be of type Fixnum")
  end
end
