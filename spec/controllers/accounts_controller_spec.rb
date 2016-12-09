require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:account) { build_stubbed(:account) }

  let(:valid_attributes) { attributes_for :account }
  let(:invalid_attributes) { attributes_for :invalid_account }

  before :each do
    Account.stub(:find).with(account.id.to_s).and_return(account)
    account.stub(:save).and_return(true)
  end
=begin
  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "accounts#new" do
      before :each do
        get :new
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new account" do
        expect(assigns(:account)).to be_new_record
        expect(assigns(:account)).to be_a_new(Account)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "account#show" do
      before :each do
        get :show, id: account.id
      end

      it "assigns @account" do
        expect(assigns(:account)).to eq account
      end

      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end

    describe "accounts#edit" do
      before :each do
        get :edit, id: account.id
      end

      it "assigns the requested account to account" do
        expect(assigns(:account)).to eq account
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "accounts#create" do
      context "with valid attributes" do
        before :each do
          user.stub(:save).and_return(true)
          post :create, account: attributes_for(:account)
        end

        it "creates a new account" do
          expect(Account.exists?(assigns(:account).id)).to be_truthy
        end

        it "redirects to the new account" do
          expect(response).to redirect_to root_path
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, account: attributes_for(:invalid_account)
        end

        it "does not save the new account" do
          expect(Account.exists?(account.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "accounts#update" do
      context "with valid attributes" do
        it "locates the requested account" do
          account.stub(:update_attributes).with(valid_attributes.stringify_keys) { true }
          put :update, id: account, account: valid_attributes
          expect(assigns(:account)).to eq account
        end

        it "redirects to the updated account" do
          put :update, id: account, account: attributes_for(:account)
          expect(response).to redirect_to account
        end
      end

      context "with invalid attributes" do
        before :each do
          account.stub(:update_attributes).with(invalid_attributes.stringify_keys) { false }
          patch :update, id: account, account: invalid_attributes
        end

        it "locates the requested account" do
          expect(assigns(:account)).to eq account
        end

        it "does not change account's attributes" do
          expect(assigns(:account).attributes).to eq account.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end
  end
=end
  context "unauthorized access" do
    describe "accounts#show" do
      it "requires login" do
        get :show, id: account.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "accounts#new" do
      it "requires login" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "accounts#edit" do
      it "requires login" do
        get :edit, id: account.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "accounts#create" do
      it "requires login" do
        post :create, account: attributes_for(:account)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "accounts#update" do
      it "requires login" do
        put :update, id: account, account: valid_attributes
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
