require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "can be saved" do
    u = User.create(nickname: "bitboxer", email: "bodo@example.com", password: "mylongpassword")
    assert u.save
  end

  test "nickname must be unique" do
    u = User.create(nickname: "bitboxer2", email: "bodo2@example.com", password: "mylongpassword")
    assert u.save
    u2 = User.create(nickname: "bitboxer2", email: "bodo3@example.com", password: "mylongpassword")
    assert !u2.save
  end

  test "email must be unique" do
    u = User.create(nickname: "bitboxer3", email: "bodo4@example.com", password: "mylongpassword")
    assert u.save
    u2 = User.create(nickname: "bitboxer4", email: "bodo4@example.com", password: "mylongpassword")
    assert !u2.save
  end

  test "search user by nickname" do
    u = User.create(nickname: "bitboxer5", email: "bodo5@example.com", password: "mylongpassword")
    assert_equal u, User.find_for_database_authentication(email: "bitboxer5")
  end

  test "search user by email" do
    u = User.create(nickname: "bitboxer6", email: "bodo6@example.com", password: "mylongpassword")
    assert_equal u, User.find_for_database_authentication(email: "bodo6@example.com")
  end

  test "user can participate on single event" do
    single = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:user)
    user.single_events << single
    user.save

    assert_equal single, user.single_events.first
    assert_equal 1, user.single_events.length
  end

  test "ignore tags are not publicy viewable by default" do
    user = FactoryGirl.create(:user)
    assert !user.allow_ignore_view?
  end

  test "user doesn't change his guid" do
    user = FactoryGirl.create(:user)
    guid = user.guid

    assert_equal guid, user.guid
  end

  test "user has guid" do
    first_user = FactoryGirl.create(:user)
    second_user = FactoryGirl.create(:another_user)

    assert_not_equal first_user.guid, second_user.guid
  end

  test "user can change email only when current password is given" do
    user = FactoryGirl.create(:user)
    assert !user.update_with_password(email: "newexample@example.com")
    assert user.update_with_password(email: "newexample@example.com", current_password: "hallo123")
    user.reload
    assert_equal "newexample@example.com", user.email
  end
end
