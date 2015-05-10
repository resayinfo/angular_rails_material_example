require 'spec_helper'

describe Api::V1::RepliesController do

  before :each do
    # avoid rendering html of single page app (RSpec only)
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  let(:user) { create_bill_murray }
  let(:replies) { [create_a_reply, create_a_reply] }
  let(:user_reply) { replies[0] }
  before { stub_login user }

  context "GET" do

    describe 'replies/:id' do
      it 'returns a serialized reply' do
        get :show, {id: user_reply.id}
        expect(json_response).to have_key(:reply)
        expect(json_response[:reply][:id]).to eq(user_reply.id)
        expect(json_response[:reply][:body]).to eq(user_reply.body)
        expect(json_response[:reply][:user_id]).to eq(user_reply.user_id)
      end
    end

    describe '/replies' do
      it 'returns serialized replies' do
        get :index
        expect(json_response).to have_key(:replies)
        expect(json_response[:replies].length).to eq(Reply.count)
        expect(json_response).to have_key(:meta)
        expect(json_response[:meta]).to have_key(:pagination)
        expect(json_response[:meta][:pagination]).to have_key(:total_pages)
        expect(json_response[:meta][:pagination]).to have_key(:page)
      end
    end
  end

  context 'POST' do
    let(:post_id){ create_a_league_post.id }
    let(:new_reply) do
      {
        body: reply_body,
        user_id: user.id,
        post_id: post_id
      }
    end

    context '/replies' do
      describe 'with valid data' do
        let(:reply_body){ 'We know this is your homework, Larry.' }
        it 'creates new reply' do
          old_count = Reply.count
          reply_hash = new_reply.dup
          expected_hash = reply_hash.dup
          post :create, {reply: reply_hash}
          expect(response.status).to eq(201)
          expect(Reply.count).to eq(old_count + 1)
          reply = json_response[:reply]
          expect(reply[:body]).to eq reply_body
          expect(reply[:user_id]).to eq user.id
          expect(reply[:post_id]).to eq post_id
        end
      end

      describe 'with invalid data' do
        let(:reply_body){ nil }

        it 'returns validation error' do
          old_count = Reply.count
          post :create, {reply: new_reply}
          expect(response.status).to eq(422)
          expect(Reply.count).to eq(old_count)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key(:body)
        end
      end
    end
  end

  context 'PUT /replies/:id' do
    describe 'with valid data' do
      let(:new_body) { 'That rug really tied the room together.' }
      let(:update_to_reply) { {body: new_body} }

      it 'updates reply' do
        put :update, {id: user_reply.id, reply: update_to_reply}
        expect(Reply.find(user_reply.id).body).to eq new_body
        expect(response.status).to eq(204)
      end
    end

    describe 'with invalid data' do
      let(:update_to_reply) { {body: ''} }

      it 'does not updates reply' do
        put :update, {id: user_reply.id, reply: update_to_reply}
        expect(Reply.find(user_reply.id).body).to eq user_reply.body
        expect(response.status).to eq(422)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors]).to have_key(:body)
      end
    end
  end
end