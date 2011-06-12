require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "can be saved" do
    u = User.create(:email => "bodo@example.com", :password => "mylongpassword")
    assert u.save
  end

end

