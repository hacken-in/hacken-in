require "spec_helper"
require "cancan/matchers"

describe Ability do
  let :ability do
    described_class.new(nil)
  end

  [Comment, User].each do |klass|
    [:create, :update, :destroy].each do |action|
      it "anonym can't #{action} #{klass}" do
        ability.should_not be_able_to action, klass
      end
    end
  end

  [Event, SingleEvent, Comment, User].each do |klass|
    it "anonym can show #{klass}" do
      ability.should be_able_to :show, klass
    end
  end
end
