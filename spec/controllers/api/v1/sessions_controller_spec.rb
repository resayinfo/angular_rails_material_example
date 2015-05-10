require 'spec_helper'

describe  Api::V1::SessionsController do

  let!(:user) { User.new id: 1, username: 'Luke', email: 'luke@skywalker.com', password: 'password' }
  let(:user_ability) { Ability.new user }

  before :each do
    # avoid rendering html of single page app (RSpec only)
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  # create
  # ---------------------------------------------
  describe "POST create" do
    context "with valid username in username params" do
      before do
        expect(user).to receive(:authenticate).with(user.password).and_return true
      end

      it "a session is created and a user is returned" do
        expect(User).to receive(:find_by_downcased_username).with(user.username.downcase).and_return user
        post :create, {username: user.username, password: user.password}
        expected_json = {user: user}.to_json(ability: user_ability)
        expect(response.body).to eq expected_json
      end
    end

    context "with valid email in username params" do
      it "a session is created and a user is returned" do
        expect(User).to receive(:find_by_email).with(user.email).and_return user
        post :create, {username: user.email, password: user.password}
        expected_json = {user: user}.to_json(ability: user_ability)
        expect(response.body).to eq expected_json
      end
    end

    context "with invalid params" do
      it "a user is not logged in with an invalid password" do
        post :create, {username: user.username, password: user.password.reverse!}
        expect(response.body).to eq({}.to_json)
      end
      it "a user is not logged with an invalid username" do
        post :create, {username: user.username.reverse!, password: user.password}
        expect(response.body).to eq({}.to_json)
      end
    end


    # delete
    # ---------------------------------------------
    describe "DELETE destroy" do
      before :each do
        stub_login user
      end
      it "returns false status of authorized" do
        delete :destroy, {id: user.to_param}
        expect(response.body).to eq({}.to_json)
      end
      it "destroys the session" do
        delete :destroy, {id: user.to_param}
        expect(session[:user_id]).to be_nil
      end
    end

  end

end