# encoding: utf-8
FactoryGirl.define do
  factory :welcome_content do 
    box_1({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    box_2({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    box_3({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    box_4({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    box_5({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    box_6({"type"=>"BlogPost", "type_id"=>"1", "image_id"=>""})
    carousel({"carousel_Bpost_start"=>"1", "carousel_image_start"=>""})
  end
end
