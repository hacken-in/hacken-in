require 'spec_helper'

describe Suggestion do
  it "should validates presence of description" do
    suggestion = FactoryGirl.build :suggestion, description: nil
    suggestion.should_not be_valid
  end

end
