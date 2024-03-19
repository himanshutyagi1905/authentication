# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }

    it "returns a success response" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "renders the user as JSON" do
      get :show, params: { id: user.id }
      expect(response.body).to eq(user.to_json)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { { user: attributes_for(:user) } }

      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns a :created response" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "PUT #update" do
  let(:user) { create(:user) }

  context "with valid parameters" do
    it "updates the user" do
      put :update, params: { id: user.id, user: { name: "Updated Name" } }
      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq("Updated Name")
    end
  end

  context "with invalid parameters" do
    it "does not update the user" do
      put :update, params: { id: user.id, user: { email: "invalid_email" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.email).not_to eq("invalid_email")
    end
  end

  context "when user is not found" do
    it "returns not found" do
      put :update, params: { id: "nonexistent_id", user: { name: "Updated Name" } }
      expect(response).to have_http_status(:not_found)
    end
  end
end

 describe "DELETE #destroy" do
    context "when the user exists" do
      let!(:user) { create(:user) }

      it "destroys the user" do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end

      it "returns a no content response" do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user does not exist" do
      it "returns a not found response" do
        delete :destroy, params: { id: 999 } # Assuming 999 is not a valid user ID
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
