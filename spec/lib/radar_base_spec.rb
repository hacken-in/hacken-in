require 'spec_helper'

describe Radar::Base do
  let(:radar) {
    Radar::Base.new(RadarSetting.create())
  }

  it "should handle postgres type casts (GitHub issue #591)" do
    expect{ radar.mark_missing(nil, [1,2,3]) }.not_to raise_error
  end
end
