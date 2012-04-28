FactoryGirl.define do
  factory :bodo, :class => 'user' do
    nickname 'bodo'
    email 'bodo@wannawork.de'
    password "hallo123"
    password_confirmation "hallo123"
    guid 'bodoguid'
    admin true
  end

  factory :user, :class => 'user' do
    nickname 'tester'
    email 'tester@example.com'
    password "hallo123"
    password_confirmation "hallo123"
    guid 'userguid'
  end

  factory :another_user, :class => 'user' do
    nickname 'tester_two'
    email 'tester_two@example.com'
    password "hallo123"
    password_confirmation "hallo123"
    guid 'anotheruserguid'
  end

end
