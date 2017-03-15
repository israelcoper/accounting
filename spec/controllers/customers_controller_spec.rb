require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:customer) { build_stubbed(:customer) }

  let(:valid_attributes) { attributes_for :customer }
  let(:invalid_attributes) { attributes_for :invalid_person }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
    Person.stub(:find).with(customer.id.to_s).and_return(customer)
    customer.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "customers#index" do
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

    describe "customers#show" do
      before :each do
        get :show, account_id: user.account_id, id: customer.id
      end
      
      it "assigns the requested customer to @customer" do
        expect(assigns(:customer)).to eq customer
      end

      it "render the :show template" do
        expect(response).to render_template :show
      end
    end

    describe "customers#new" do
      before :each do
        get :new, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new customer" do
        expect(assigns(:customer)).to be_new_record
        expect(assigns(:customer)).to be_a_new(Person)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "customers#edit" do
      before :each do
        get :edit, { account_id: user.account_id, id: customer.id } 
      end

      it "assigns the requested customer to @customer" do
        expect(assigns(:customer)).to eq customer
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "customers#create" do
      context "with valid attributes" do
        before :each do
          @request.env['HTTP_REFERER'] = account_customers_path(user.account_id)
          post :create, { account_id: user.account_id, person: attributes_for(:customer) }
        end

        it "creates a new customer" do
          expect(Person.exists?(assigns(:customer).id)).to be_truthy
        end

        it "redirects to the new customer" do
          expect(response).to redirect_to account_customers_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: user.account_id, person: attributes_for(:invalid_person) }
        end

        it "does not save the new customer" do
          expect(Person.exists?(customer.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "customers#update" do
      context "with valid attributes" do
        it "locates the requested customer" do
          customer.stub(:update).with(valid_attributes.except!(:person_type, :balance).stringify_keys) { true }
          put :update, { account_id: user.account_id, id: customer.id, person: valid_attributes }
          expect(assigns(:customer)).to eq customer
        end

        it "redirects to the updated customer" do
          put :update, { account_id: user.account_id, id: customer.id, person: valid_attributes }
          expect(response).to redirect_to account_customers_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          customer.stub(:update).with(invalid_attributes.except!(:balance).stringify_keys) { false }
          patch :update, { account_id: user.account_id, id: customer.id, person: invalid_attributes }
        end

        it "locates the requested customer" do
          expect(assigns(:customer)).to eq customer
        end

        it "does not change customer's attributes" do
          expect(assigns(:customer).attributes).to eq customer.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

  end

  context "unauthorized access" do
    describe "customers#index" do
      it "requires login" do
        get :index, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "customers#show" do
      it "requires login" do
        get :show, { account_id: user.account_id, id: customer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "customers#new" do
      it "requires login" do
        get :new, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "customers#edit" do
      it "requires login" do
        get :edit, { account_id: user.account_id, id: customer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "customers#create" do
      it "requires login" do
        post :create, { account_id: user.account_id, user: attributes_for(:customer) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "customers#update" do
      it "requires login" do
        put :update, { account_id: user.account_id, id: customer.id, user: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
