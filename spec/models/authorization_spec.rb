require 'spec_helper'

describe Authorization do
  let(:auth) {OmniAuth::AuthHash.new(JSON.parse(File.read(token_path), symbolize_names: true))}

  context "while authenticating with GitHub" do
    let(:token_path) {File.join("spec", "support", "fixtures", "oauth-token-github-klaustopher.json")}

    context "the extracted auth data" do
      subject {Authorization.extract_auth_data(auth)}

      it "should be the right data" do
        should eq ({
          provider: "github",
          uid: "522537",
          token: "SOMETOKENTHATDOESNOTINTERESTYOU",
          secret: nil
        })
      end
    end

    context "the extracted nick data" do
      subject {Authorization.extract_nick_data(auth)}

      it "should be the right data" do
        should eq ({
          github: "klaustopher"
        })
      end
    end
  end

  context "while authenticating with Twitter" do
    let(:token_path) {File.join("spec", "support", "fixtures", "oauth-token-twitter-klaustopher.json")}

    context "the extracted auth data" do
      subject {Authorization.extract_auth_data(auth)}

      it "should be the right data" do
        should eq ({
          provider: "twitter",
          uid: "41772499",
          token: "UNDMEINTOKENAUCHNICHT",
          secret: "MEINSECRETGEHTDICHNIXAN"
        })
      end
    end

    context "the extracted nick data" do
      subject {Authorization.extract_nick_data(auth)}

      it "should be the right data" do
        should eq ({
          twitter: "klaustopher"
        })
      end
    end
  end

end
