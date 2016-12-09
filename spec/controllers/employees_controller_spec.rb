require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:user) { build_stubbed(:user) }

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index, { account_id: user.account_id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "unauthorized access" do
  end

end
