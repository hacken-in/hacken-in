FactoryGirl.define do
  factory :bodo, :class => 'user' do
    email 'bodo@wannawork.de'
    password "hallo123"
    password_confirmation "hallo123"
  end

  factory :user, :class => 'user' do
    email 'tester@example.com'
    password "hallo123"
    password_confirmation "hallo123"
  end

end
