require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:item) { build_stubbed(:item) }

  let(:valid_attributes) { attributes_for :item }
  let(:invalid_attributes) { attributes_for :invalid_item }

  before :each do
    Item.stub(:find).with(item.id.to_s).and_return(item)
    item.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "items#index" do
      before :each do
        get :index, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "render the :index template" do
        expect(response).to render_template :index
      end
    end

    describe "items#new" do
      before :each do
        get :new, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new item" do
        expect(assigns(:item)).to be_new_record
        expect(assigns(:item)).to be_a_new(Item)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "items#edit" do
      before :each do
        get :edit, { account_id: user.account_id, id: item.id } 
      end

      it "assigns the requested product to @item" do
        expect(assigns(:item)).to eq item
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "items#create" do
      context "with valid attributes" do
        before :each do
          @request.env['HTTP_REFERER'] = account_items_path(user.account_id)
          post :create, { account_id: user.account_id, item: valid_attributes }
        end

        it "creates a new item" do
          expect(Item.exists?(assigns(:item).id)).to be_truthy
        end

        it "redirects to the new item" do
          expect(response).to redirect_to account_items_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: user.account_id, item: attributes_for(:invalid_item) }
        end

        it "does not save the new item" do
          expect(Item.exists?(item.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "items#update" do
      context "with valid attributes" do
        it "locates the requested item" do
          item.stub(:update).with(valid_attributes.stringify_keys) { true }
          put :update, { account_id: user.account_id, id: item.id, item: valid_attributes }
          expect(assigns(:item)).to eq item
        end

        it "redirects to the updated item" do
          put :update, { account_id: user.account_id, id: item.id, item: valid_attributes }
          expect(response).to redirect_to account_items_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          item.stub(:update).with(invalid_attributes.stringify_keys) { false }
          patch :update, { account_id: user.account_id, id: item.id, item: invalid_attributes }
        end

        it "locates the requested item" do
          expect(assigns(:item)).to eq item
        end

        it "does not change item's attributes" do
          expect(assigns(:item).attributes).to eq item.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

  end

  context "unauthorized access" do
    describe "items#index" do
      it "requires login" do
        get :index, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "items#new" do
      it "requires login" do
        get :new, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "items#edit" do
      it "requires login" do
        get :edit, { account_id: user.account_id, id: item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "items#create" do
      it "requires login" do
        post :create, { account_id: user.account_id, item: attributes_for(:item) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "items#update" do
      it "requires login" do
        put :update, { account_id: user.account_id, id: item.id, item: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
