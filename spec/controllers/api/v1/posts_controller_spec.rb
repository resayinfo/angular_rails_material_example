require 'spec_helper'

describe Api::V1::PostsController do

  before :each do
    # avoid rendering html of single page app (RSpec only)
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  let(:user) { create_bill_murray }
  let(:posts) { [create_a_league_post, create_a_league_post] }
  let(:user_post) { posts[0] }
  before { stub_login user }

  context "GET" do
    let(:expected) do
      {
        post: {
          title: user_post.title,
          user_id: user_post.user_id
        }
      }
    end


    describe 'posts/:id' do
      it 'returns a serialized post' do
        get :show, {id: user_post.id}
        expect(json_response).to have_key(:post)
        expect(json_response[:post][:id]).to eq(user_post.id)
        expect(json_response[:post][:title]).to eq(user_post.title)
        expect(json_response[:post][:user_id]).to eq(user_post.user_id)
        expect(json_response[:post][:can_read]).not_to be_nil
      end
    end

    describe '/posts' do
      it 'returns serialized posts' do
        get :index
        expect(json_response).to have_key(:posts)
        expect(json_response[:posts].length).to eq(Post.active.count)
        expect(json_response).to have_key(:meta)
        expect(json_response[:meta]).to have_key(:pagination)
        expect(json_response[:meta][:pagination]).to have_key(:total_pages)
        expect(json_response[:meta][:pagination]).to have_key(:page)
      end
    end
  end

  context 'POST' do
    let(:league_attrs){ {name: league_name, url: 'http://yahoo.com/1234/settings'} }
    let(:new_post) do
      {
        title: post_title,
        user_id: user.id,
        league_type: 'FootballLeague',
        league_attributes: league_attrs
      }
    end

    context '/posts' do
      describe 'with valid data' do
        let(:post_title){ 'We know this is your homework, Larry.' }
        let(:league_name){ "Culpepper's Cannons" }
        it 'creates new post' do
          old_count = Post.count
          post_hash = new_post.dup
          expected_hash = post_hash.dup
          post :create, {post: post_hash}
          expect(response.status).to eq(201)
          expect(Post.count).to eq(old_count + 1)
          post = json_response[:post]
          expect(post[:league_type]).to eq('FootballLeague')
          expect(post[:league][:url]).to eq('http://yahoo.com/1234/settings')
          expect(post[:league][:name]).to eq("Culpepper's Cannons")
          expect(post[:league][:id]).not_to be_nil
        end
      end

      describe 'with invalid data' do
        let(:post_title){ nil }
        let(:league_name){ nil }

        it 'returns validation error' do
          old_count = Post.count
          post :create, {post: new_post}
          expect(response.status).to eq(422)
          expect(Post.count).to eq(old_count)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key(:title)
          expect(json_response[:errors]).to have_key(:"league.name")
        end
      end
    end
  end

  context 'PUT /posts/:id' do
    describe 'with valid data' do
      let(:new_body) { 'That rug really tied the room together.' }
      let(:update_to_post) { {body: new_body} }

      it 'updates post' do
        put :update, {id: user_post.id, post: update_to_post}
        expect(Post.find(user_post.id).body).to eq new_body
        expect(response.status).to eq(204)
      end
    end

    describe 'with invalid data' do
      let(:update_to_post) { {title: ''} }

      it 'does not updates post' do
        put :update, {id: user_post.id, post: update_to_post}
        expect(Post.find(user_post.id).body).to eq user_post.body
        expect(response.status).to eq(422)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors]).to have_key(:title)
        expect(json_response[:errors]).not_to have_key(:"league.name")
      end
    end
  end
end