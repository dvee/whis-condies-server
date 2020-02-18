require File.expand_path '../spec_helper.rb', __FILE__
require_relative '../services'

describe ConditionsGetter do
  let!(:getter) { described_class.new }
  describe "call" do
    context "when the cache is invalid" do
      before do
        getter.instance_variable_set(:@last_fetch, Time.now - 60 * 60 * 1) # one hour ago
        getter.instance_variable_set(:@cache, {})
      end
      it "should fetch the latest conditions from the web" do
        allow(getter).to receive(:fetch_conditions).and_return(
          {
            "village" => 10.0,
            "mid" => 0.5,
            "peak" => -5.0,
            "last_updated" => Time.now
          }
        )
        result = getter.call
        expect(result["village"]).to eq 10.0
      end
    end

    context "when the cache is valid" do
      before do
        getter.instance_variable_set(:@last_fetch, Time.now - 60 * 1) # one minute ago
      end
      it "uses the cached values" do
        getter.call
        expect(getter).not_to receive(:fetch_conditions)
      end
    end
  end
end