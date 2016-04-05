require 'spec_helper'

describe WelcomeController, type: :controller do
  include Devise::TestHelpers
  context "index" do
    it "should redirect to /deutschland if no region is set in session" do
      get :index
      expect(response).to redirect_to "/deutschland"
    end

    it "should redirect to /koeln if region koeln is set in session" do
      session[:region] = "koeln"
      get :index
      expect(response).to redirect_to "/koeln"
    end
  end

  context "move_to" do
    it "should store region in session and redirect to it if it exists" do
      FactoryGirl.create(:koeln_region)
      get :move_to, region: "koeln"
      expect(response).to redirect_to "/koeln"
      expect(session[:region]).to eq("koeln")
    end

    it "should redirect to /deutschland if region is not avialable" do
      get :move_to, region: "notavailable"
      expect(response).to redirect_to "/deutschland"
    end
  end

  context "warn" do
    render_views
    it "should warn users visiting a staging app" do
      Rails.configuration.x.release_stage = :master
      FactoryGirl.create(:koeln_region)
      get 'deutschland'
      expect(response.body).to match(/Achtung, das ist unsere Test-Umgebung/)
      get :move_to, region: "koeln"
      get 'deutschland'
      expect(response.body).to_not match(/Achtung, das ist unsere Test-Umgebung/)
    end
  end

end
