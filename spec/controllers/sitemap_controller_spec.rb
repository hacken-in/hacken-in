require 'spec_helper'

describe SitemapController, type: :controller do
  describe "#index" do
    context "with xml format" do
      it "succeeds" do
        get :index, format: "xml"
        expect(response).to be_success
      end
    end

    context "with html format" do
      it "raises error" do
        expect { get :index, format: "html" }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
