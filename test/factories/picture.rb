include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    carousel_image { fixture_file_upload(Rails.root.to_s + '/app/assets/images/test-werbung.png', "image/png") }
    box_image { fixture_file_upload(Rails.root.to_s + '/app/assets/images/test-werbung.png', "image/png") }
    title "Some title"
  end
end
