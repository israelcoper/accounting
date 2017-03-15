require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:user) { build_stubbed(:user) }
  let(:employee) { build_stubbed(:employee) }

  let(:valid_attributes) { attributes_for :employee }
  let(:invalid_attributes) { attributes_for :invalid_person }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
    Person.stub(:find).with(employee.id.to_s).and_return(employee)
    employee.stub(:save).and_return(true)
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "employees#index" do
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

    describe "employees#new" do
      before :each do
        get :new, { account_id: user.account_id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new employee" do
        expect(assigns(:employee)).to be_new_record
        expect(assigns(:employee)).to be_a_new(Person)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "employees#edit" do
      before :each do
        get :edit, { account_id: user.account_id, id: employee.id } 
      end

      it "assigns the requested employee to @employee" do
        expect(assigns(:employee)).to eq employee
      end

      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    describe "employees#create" do
      context "with valid attributes" do
        before :each do
          post :create, { account_id: user.account_id, person: attributes_for(:employee) }
        end

        it "creates a new employee" do
          expect(Person.exists?(assigns(:employee).id)).to be_truthy
        end

        it "redirects to the new employee" do
          expect(response).to redirect_to account_employees_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, { account_id: user.account_id, person: attributes_for(:invalid_person) }
        end

        it "does not save the new employee" do
          expect(Person.exists?(employee.id)).to be_falsey
        end

        it "re-renders the :new method" do
          expect(response).to render_template :new
        end
      end
    end

    describe "employees#update" do
      context "with valid attributes" do
        it "locates the requested employee" do
          employee.stub(:update).with(valid_attributes.except!(:person_type, :balance).stringify_keys) { true }
          put :update, { account_id: user.account_id, id: employee.id, person: valid_attributes }
          expect(assigns(:employee)).to eq employee
        end

        it "redirects to the updated employee" do
          put :update, { account_id: user.account_id, id: employee.id, person: valid_attributes }
          expect(response).to redirect_to account_employees_path(user.account_id)
        end
      end

      context "with invalid attributes" do
        before :each do
          employee.stub(:update).with(invalid_attributes.except!(:balance).stringify_keys) { false }
          patch :update, { account_id: user.account_id, id: employee.id, person: invalid_attributes }
        end

        it "locates the requested employee" do
          expect(assigns(:employee)).to eq employee
        end

        it "does not change employee's attributes" do
          expect(assigns(:employee).attributes).to eq employee.attributes
        end

        it "re-renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
    end

  end

  context "unauthorized access" do
    describe "employees#index" do
      it "requires login" do
        get :index, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "employees#new" do
      it "requires login" do
        get :new, { account_id: user.account_id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "employees#edit" do
      it "requires login" do
        get :edit, { account_id: user.account_id, id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "employees#create" do
      it "requires login" do
        post :create, { account_id: user.account_id, user: attributes_for(:user) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "employees#update" do
      it "requires login" do
        put :update, { account_id: user.account_id, id: user.id, user: valid_attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
