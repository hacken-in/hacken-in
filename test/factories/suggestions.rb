FactoryGirl.define do
  factory :suggestion, class: 'suggestion' do
    name "My fancy suggestion"
    occurrence "Every second tuesday"
    description "This is a fancy event. It includes Pirates. And Ponies."
    place "At my house. Don't be creepy."
    more({ "twitter" => "freedomfightersunited",
           "homepage" => "http://www.nick.de/shows/1008-my-little-pony" })
  end
end
