FactoryGirl.define do
  factory :bodo, :class => 'user' do
    nickname 'bodo'
    email 'bodo@wannawork.de'
    password "hallo123"
    password_confirmation "hallo123"
    admin true
  end

  factory :user, :class => 'user' do
    nickname 'tester'
    email 'tester@example.com'
    password "hallo123"
    password_confirmation "hallo123"
  end

end
