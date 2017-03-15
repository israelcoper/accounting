require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { build_stubbed(:user) }
  let(:user) { build_stubbed(:user) }

  let(:valid_attributes) { attributes_for :user }
  let(:invalid_attributes) { attributes_for :invalid_user }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
    User.stub(:find).with(user.id.to_s).and_return(user)
    user.stub(:save).and_return(true)
  end
=begin
  context "authorized access" do
    before :each do
      sign_in current_user
    end

    describe "users#index" do
      before :each do
        get :index, { account_id: current_user.account_id }
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
        get :new, { account_id: current_user.account_id }
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
        get :edit, { account_id: current_user.account_id, id: user.id } 
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
          post :create, { account_id: current_user.account_id, user: attributes_for(:user) }
        end

        it "creates a new user" do
          expect(User.exists?(assigns(:user).id)).to be_truthy
        end

        it "redirects to the new user" do
          expect(response).to redirect_to edit_account_user_path(current_user.account_id, User.last)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: current_user.account_id, user: attributes_for(:invalid_user) }
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
          put :update, { account_id: current_user.account_id, id: user.id, user: valid_attributes }
          expect(assigns(:user)).to eq user
        end

        it "redirects to the updated account" do
          put :update, { account_id: current_user.account_id, id: user.id, user: attributes_for(:user) }
          expect(response).to redirect_to edit_account_user_path(current_user.account_id, user)
        end
      end

      context "with invalid attributes" do
        before :each do
          user.stub(:update).with(invalid_attributes.stringify_keys) { false }
          patch :update, { account_id: current_user.account_id, id: user.id, user: invalid_attributes }
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
        delete :destroy, { account_id: current_user.account_id, id: user.id }
      end

      it "deletes the user" do
        expect(User.exists?(user.id)).to be_falsey
      end

      it "redirects to users#index" do
        expect(response).to redirect_to account_users_path(current_user.account_id)
      end
    end
  end
=end
  context "authorized access" do
    before :each do
      sign_in current_user
    end

    describe "users#lock" do
      let!(:locked_at) { Time.zone.now }

      before :each do
        user.stub(:locked).and_return(locked_at)
        put :lock, { account_id: current_user.account_id, id: user.id }
      end

      it "locks the user" do
        expect(user.locked).to eq locked_at
      end

      it "redirects to users#index" do
        expect(response).to redirect_to account_users_path(current_user.account_id)
      end
    end

    describe "users#unlock" do
      before :each do
        user.stub(:unlocked).and_return(nil)
        put :unlock, { account_id: current_user.account_id, id: user.id }
      end

      it "unlocks the user" do
        expect(user.unlocked).to eq nil
      end

      it "redirects to users#index" do
        expect(response).to redirect_to account_users_path(current_user.account_id)
      end
    end
  end

  context "unauthorized access" do
    describe "users#index" do
      it "requires login" do
        get :index, { account_id: current_user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#new" do
      it "requires login" do
        get :new, { account_id: current_user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#edit" do
      it "requires login" do
        get :edit, { account_id: current_user.account_id, id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#create" do
      it "requires login" do
        post :create, { account_id: current_user.account_id, user: attributes_for(:user) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#update" do
      it "requires login" do
        put :update, { account_id: current_user.account_id, id: user.id, user: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "users#destroy" do
      it "requires login" do
        delete :destroy, { account_id: current_user.account_id, id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
