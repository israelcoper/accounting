require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:supplier) { build_stubbed(:supplier) }

  let(:valid_attributes) { attributes_for :supplier }
  let(:invalid_attributes) { attributes_for :invalid_person }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
    Person.stub(:find).with(supplier.id.to_s).and_return(supplier)
    supplier.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "suppliers#index" do
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

    describe "suppliers#show" do
      before :each do
        get :show, account_id: user.account_id, id: supplier.id
      end
      
      it "assigns the requested supplier to @supplier" do
        expect(assigns(:supplier)).to eq supplier
      end

      it "render the :show template" do
        expect(response).to render_template :show
      end
    end

    describe "suppliers#new" do
      before :each do
        get :new, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new supplier" do
        expect(assigns(:supplier)).to be_new_record
        expect(assigns(:supplier)).to be_a_new(Person)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "suppliers#edit" do
      before :each do
        get :edit, { account_id: user.account_id, id: supplier.id } 
      end

      it "assigns the requested supplier to @supplier" do
        expect(assigns(:supplier)).to eq supplier
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "suppliers#create" do
      context "with valid attributes" do
        before :each do
          @request.env["HTTP_REFERER"] = account_suppliers_path(user.account_id)
          post :create, { account_id: user.account_id, person: attributes_for(:supplier) }
        end

        it "creates a new supplier" do
          expect(Person.exists?(assigns(:supplier).id)).to be_truthy
        end

        it "redirects to the new supplier" do
          expect(response).to redirect_to account_suppliers_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: user.account_id, person: attributes_for(:invalid_person) }
        end

        it "does not save the new supplier" do
          expect(Person.exists?(supplier.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "suppliers#update" do
      context "with valid attributes" do
        it "locates the requested supplier" do
          supplier.stub(:update).with(valid_attributes.except!(:person_type, :balance).stringify_keys) { true }
          put :update, { account_id: user.account_id, id: supplier.id, person: valid_attributes }
          expect(assigns(:supplier)).to eq supplier
        end

        it "redirects to the updated supplier" do
          put :update, { account_id: user.account_id, id: supplier.id, person: valid_attributes }
          expect(response).to redirect_to account_suppliers_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          supplier.stub(:update).with(invalid_attributes.except!(:balance).stringify_keys) { false }
          patch :update, { account_id: user.account_id, id: supplier.id, person: invalid_attributes }
        end

        it "locates the requested supplier" do
          expect(assigns(:supplier)).to eq supplier
        end

        it "does not change supplier's attributes" do
          expect(assigns(:supplier).attributes).to eq supplier.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

  end

  context "unauthorized access" do
    describe "suppliers#index" do
      it "requires login" do
        get :index, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "suppliers#show" do
      it "requires login" do
        get :show, { account_id: user.account_id, id: supplier.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "suppliers#new" do
      it "requires login" do
        get :new, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "suppliers#edit" do
      it "requires login" do
        get :edit, { account_id: user.account_id, id: supplier.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "suppliers#create" do
      it "requires login" do
        post :create, { account_id: user.account_id, user: attributes_for(:supplier) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "suppliers#update" do
      it "requires login" do
        put :update, { account_id: user.account_id, id: supplier.id, user: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
