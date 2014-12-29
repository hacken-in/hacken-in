require 'spec_helper'

describe SitemapController, type: :controller do
  describe "#show" do
    context "with xml format" do
      it "succeeds" do
        get :show, format: "xml"
        expect(response).to be_success
      end
    end

    context "with html format" do
      it "raises error" do
        expect { get :show, format: "html" }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
