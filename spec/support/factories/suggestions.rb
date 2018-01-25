FactoryBot.define do
  factory :suggestion, class: 'suggestion' do
    email_address "test@example.com"
    description "This is a fancy event. It includes Pirates. And Ponies."
  end
end
