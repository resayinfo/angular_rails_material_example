require 'spec_helper'

describe Api::V1::UsersController do

  before :each do
    # avoid rendering html of single page app (RSpec only)
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  let(:user) { create_bill_murray }

  context "GET" do
    let(:expected) do
      {
        user: {
          title: user.title,
          user_id: user.user_id
        }
      }
    end


    describe 'users/:id' do
      it 'returns a serialized user' do
        get :show, {id: user.id}
        expect(json_response).to have_key(:user)
        expect(json_response[:user][:id]).to eq(user.id)
        expect(json_response[:user][:username]).to eq(user.username)
        expect(json_response[:user][:email]).to eq(user.email)
        expect(json_response[:user][:can_read]).not_to be_nil
      end
    end

    describe '/users' do
      it 'returns serialized users' do
        get :index
        expect(json_response).to have_key(:users)
        expect(json_response[:users].length).to eq(User.count)
        expect(json_response).to have_key(:meta)
        expect(json_response[:meta]).to have_key(:pagination)
        expect(json_response[:meta][:pagination]).to have_key(:total_pages)
        expect(json_response[:meta][:pagination]).to have_key(:page)
      end
    end
  end

  context 'POST' do
    let(:new_user) do
      {
        username: user_username,
        email: user_email,
        password: user_password,
        password_confirmation: user_password
      }
    end

    context '/users' do
      describe 'with valid data' do
        let(:user_username){ 'SomeNewGuy' }
        let(:user_email){ 'SomeNewGuy@emails.com' }
        let(:user_password){ 'CrazyPa$$w0rD' }

        it 'creates new user' do
          old_count = User.count
          user_hash = new_user.dup
          expected_hash = user_hash.dup
          post :create, {user: user_hash}
          expect(response.status).to eq(201)
          expect(User.count).to eq(old_count + 1)
          user = json_response[:user]
          expect(user[:username]).to eq(user_username)
          expect(user[:email]).to eq(user_email.downcase)
        end
      end

      describe 'with invalid data' do
        let(:user_username){ '' }
        let(:user_email){ '' }
        let(:user_password){ '' }

        it 'returns validation error' do
          old_count = User.count
          post :create, {user: new_user}
          expect(response.status).to eq(422)
          expect(User.count).to eq(old_count)
          expect(json_response[:errors][:username]).to match_array(["may only consist of letters and numbers", "is too short (minimum is 3 characters)"])
          expect(json_response[:errors][:password]).to match_array(["can't be blank"])
          expect(json_response[:errors][:email]).to match_array(["must contain the '@' symbol", "is too short (minimum is 3 characters)"])
        end
      end
    end
  end

  context 'PUT /users/:id' do
    before { stub_login user }

    describe 'with valid data' do
      let(:new_email) { 'SomeUpdatedEmail@emails.com' }
      let(:update_to_user) { {email: new_email} }

      it 'updates user' do
        put :update, {id: user.id, user: update_to_user}
        expect(User.find(user.id).email).to eq new_email.downcase
        expect(response.status).to eq(204)
      end
    end

    describe 'with invalid data' do
      let(:update_to_user) { {email: ''} }

      it 'does not updates user' do
        put :update, {id: user.id, user: update_to_user}
        expect(User.find(user.id).email).to eq user.email
        expect(response.status).to eq(422)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors]).to have_key(:email)
      end
    end
  end
end