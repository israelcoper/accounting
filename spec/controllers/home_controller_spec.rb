require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { build_stubbed(:user) }

  before :each do
    controller.class.skip_before_filter :current_account_has_account_chart!
  end

  context "authorized access" do
    before :each do
      sign_in user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "unauthorized access" do
  end

end
