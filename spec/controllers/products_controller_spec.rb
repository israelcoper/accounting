require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:product) { build_stubbed(:product) }

  let(:valid_attributes) { attributes_for :product }
  let(:invalid_attributes) { attributes_for :invalid_product }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
    Product.stub(:find).with(product.id.to_s).and_return(product)
    product.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "products#index" do
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

    describe "products#new" do
      before :each do
        get :new, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new product" do
        expect(assigns(:product)).to be_new_record
        expect(assigns(:product)).to be_a_new(Product)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "products#edit" do
      before :each do
        get :edit, { account_id: user.account_id, id: product.id } 
      end

      it "assigns the requested product to @product" do
        expect(assigns(:product)).to eq product
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "products#create" do
      context "with valid attributes" do
        before :each do
          @request.env['HTTP_REFERER'] = account_products_path(user.account_id)
          post :create, { account_id: user.account_id, product: valid_attributes }
        end

        it "creates a new product" do
          expect(Product.exists?(assigns(:product).id)).to be_truthy
        end

        it "redirects to the new product" do
          expect(response).to redirect_to account_products_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: user.account_id, product: attributes_for(:invalid_product) }
        end

        it "does not save the new product" do
          expect(Product.exists?(product.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "products#update" do
      context "with valid attributes" do
        it "locates the requested product" do
          product.stub(:update).with(valid_attributes.stringify_keys) { true }
          put :update, { account_id: user.account_id, id: product.id, product: valid_attributes }
          expect(assigns(:product)).to eq product
        end

        it "redirects to the updated product" do
          put :update, { account_id: user.account_id, id: product.id, product: valid_attributes }
          expect(response).to redirect_to account_products_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          product.stub(:update).with(invalid_attributes.stringify_keys) { false }
          patch :update, { account_id: user.account_id, id: product.id, product: invalid_attributes }
        end

        it "locates the requested product" do
          expect(assigns(:product)).to eq product
        end

        it "does not change product's attributes" do
          expect(assigns(:product).attributes).to eq product.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

  end

  context "unauthorized access" do
    describe "products#index" do
      it "requires login" do
        get :index, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "products#new" do
      it "requires login" do
        get :new, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "products#edit" do
      it "requires login" do
        get :edit, { account_id: user.account_id, id: product.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "products#create" do
      it "requires login" do
        post :create, { account_id: user.account_id, user: attributes_for(:product) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "products#update" do
      it "requires login" do
        put :update, { account_id: user.account_id, id: product.id, user: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
