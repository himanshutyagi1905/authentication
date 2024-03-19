# spec/controllers/authentication_controller_spec.rb

require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe "POST #login" do
    context "with valid credentials" do
      let(:user) { FactoryBot.create(:user, email: "test@example.com", password: "password") }

      it "returns a token and user information" do
        post :login, params: { email: user.email, password: "password" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("token", "exp", "username")
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized status" do
        post :login, params: { email: "invalid@example.com", password: "password" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error" => "unauthorized")
      end
    end
  end
end
