require 'spec_helper'

describe Api::UserTagsController do
  include Devise::TestHelpers

  [:hate, :like].each do |kind|
    it "should should create new #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      user.public_send(:"#{kind}_list") << ".net"
      user.save
      sign_in user

      expect {
        post :create, kind: kind, tags: ['tag']
        user.reload
      }.to change { user.public_send("#{kind}_list").length }.by 1
      expect(response.code).to eq("201")
    end

    it "should should not create #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)

      expect {
        post :create, kind: kind, tags: ['tag']
        user.reload
      }.to change { user.public_send("#{kind}_list").length }.by 0
      expect(response.code).to eq("401")
    end

    it "should remove #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      user.public_send(:"#{kind}_list") << "tag"
      user.save
      sign_in user

      expect {
        delete :destroy, id: 'tag', kind: kind
        user.reload
      }.to change { user.public_send("#{kind}_list").length }.by(-1)
      expect(response.code).to eq("200")
    end

    it "should remove #{kind} tag .net" do
      user = FactoryGirl.create(:bodo)
      user.public_send(:"#{kind}_list") << ".net"
      user.public_send(:"#{kind}_list") << "java"
      user.save
      sign_in user

      expect {
        delete :destroy, id: '.net', kind: kind
        user.reload
      }.to change { user.public_send("#{kind}_list").length }.by(-1)
      expect(response.code).to eq("200")
    end

    it "should should not remove #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)
      user.public_send(:"#{kind}_list") << "tag"
      user.save

      expect {
        delete :destroy, id: '.net', kind: kind
        user.reload
      }.to change { user.public_send("#{kind}_list").length }.by(0)
      expect(response.code).to eq("401")
    end
  end

  it "should should remove tag from hate if added to like" do
    user = FactoryGirl.create(:bodo)
    user.hate_list << "tag"
    user.save
    sign_in user

    post :create, kind: "like", tags: ['tag']
    user.reload
    expect(user.like_list).to eq(["tag"])
    expect(user.hate_list).to eq([])
  end

  it "should should remove tag from love if added to hate" do
    user = FactoryGirl.create(:bodo)
    user.like_list << "tag"
    user.save
    sign_in user

    post :create, kind: "hate", tags: ['tag']
    user.reload
    expect(user.hate_list).to eq(["tag"])
    expect(user.like_list).to eq([])
  end
end
