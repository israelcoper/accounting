require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { build_stubbed(:user) }
  let(:user) { build_stubbed(:user) }

  let(:valid_attributes) { attributes_for :user }
  let(:invalid_attributes) { attributes_for :invalid_user }

  before :each do
    User.stub(:find).with(user.id.to_s).and_return(user)
    user.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in current_user
    end

    describe "users#index" do
      before :each do
        get :index
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "render the :index template" do
        expect(response).to render_template :index
      end

      # it "assigns @users" do
      #   expect(assigns(:users)).to match_array [user]
      # end
    end

    describe "users#new" do
      before :each do
        get :new
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new user" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_a_new(User)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "users#edit" do
      before :each do
        get :edit, id: user.id
      end

      it "assigns the requested user to @user" do
        expect(assigns(:user)).to eq user
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "users#create" do
      context "with valid attributes" do
        before :each do
          post :create, user: attributes_for(:user)
        end

        it "creates a new user" do
          expect(User.exists?(assigns(:user).id)).to be_truthy
        end

        it "redirects to the new user" do
          expect(response).to redirect_to edit_user_path(User.last)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, user: attributes_for(:invalid_user)
        end

        it "does not save the new user" do
          expect(User.exists?(user.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "users#update" do
      context "with valid attributes" do
        it "locates the requested user" do
          user.stub(:update).with(valid_attributes.stringify_keys) { true }
          put :update, id: user, user: valid_attributes
          expect(assigns(:user)).to eq user
        end

        it "redirects to the updated account" do
          put :update, id: user, user: attributes_for(:user)
          expect(response).to redirect_to edit_user_path(user)
        end
      end

      context "with invalid attributes" do
        before :each do
          user.stub(:update).with(invalid_attributes.stringify_keys) { false }
          patch :update, id: user, user: invalid_attributes
        end

        it "locates the requested user" do
          expect(assigns(:user)).to eq user
        end

        it "does not change user's attributes" do
          expect(assigns(:user).attributes).to eq user.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

    describe "users#destroy" do
      before :each do
        user.stub(:destroy).and_return(true)
        delete :destroy, id: user
      end

      it "deletes the user" do
        expect(User.exists?(user.id)).to be_falsey
      end

      it "redirects to users#index" do
        expect(response).to redirect_to users_path
      end
    end
  end

  context "unauthorized access" do
    describe "users#index" do
      it "requires login" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#new" do
      it "requires login" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#edit" do
      it "requires login" do
        get :edit, id: user.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#create" do
      it "requires login" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#update" do
      it "requires login" do
        put :update, id: user, user: valid_attributes
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#destroy" do
      it "requires login" do
        delete :destroy, id: user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
