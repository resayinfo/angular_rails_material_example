require'spec_helper'
require 'cancan/matchers'

describe 'Ability' do
  let(:ability) { Ability.new(user) }
  subject { ability }

  let(:other_user) { User.new id: 3 }
  let(:deactivated_user) { User.new id: 4, deactivated_at: Time.now }
  let(:deleted_post) { Post.new user_id: user.id, deleted_at: Time.now }
  let(:my_post) { Post.new user_id: user.id }
  let(:other_user_post) { Post.new user_id: other_user.id }
  let(:deleted_reply) { Reply.new user_id: user.id, deleted_at: Time.now, post_id: other_user_post }
  let(:my_reply) { Reply.new user_id: user.id, post_id: other_user_post }
  let(:other_user_reply) { Reply.new user_id: other_user.id, post_id: other_user_post }
  let(:new_user) { false }

  before { allow(user).to receive(:new_record?){ new_user } }

  describe 'Admin' do
    let(:user) { User.new id: 1, admin: true }

    it do
      # Post abilities
      expect(subject).to be_able_to(:create, my_post)
      expect(subject).to be_able_to(:read, my_post)
      expect(subject).to be_able_to(:update, my_post)
      expect(subject).to be_able_to(:destroy, my_post)
      expect(subject).to be_able_to(:create, other_user_post)
      expect(subject).to be_able_to(:read, other_user_post)
      expect(subject).to be_able_to(:update, other_user_post)
      expect(subject).to be_able_to(:destroy, other_user_post)
      expect(subject).to be_able_to(:read, deleted_post)
      expect(subject).to be_able_to(:update, deleted_post)

      # Reply abilities
      expect(subject).to be_able_to(:create, my_reply)
      expect(subject).to be_able_to(:read, my_reply)
      expect(subject).to be_able_to(:update, my_reply)
      expect(subject).to be_able_to(:destroy, my_reply)
      expect(subject).to be_able_to(:create, other_user_reply)
      expect(subject).to be_able_to(:read, other_user_reply)
      expect(subject).to be_able_to(:update, other_user_reply)
      expect(subject).to be_able_to(:destroy, other_user_reply)
      expect(subject).to be_able_to(:read, deleted_reply)
      expect(subject).to be_able_to(:update, deleted_reply)

      # User abilities
      expect(subject).to be_able_to(:create, user)
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
      expect(subject).to be_able_to(:create, other_user)
      expect(subject).to be_able_to(:read, other_user)
      expect(subject).to be_able_to(:update, other_user)
      expect(subject).to be_able_to(:destroy, other_user)
      expect(subject).to be_able_to(:read, deactivated_user)
      expect(subject).to be_able_to(:update, deactivated_user)
    end
  end

  describe 'Normal' do
    let(:user) { User.new id: 2 }

    it do
      # Post abilities
      expect(subject).to be_able_to(:create, my_post)
      expect(subject).to be_able_to(:read, my_post)
      expect(subject).to be_able_to(:update, my_post)
      expect(subject).to be_able_to(:destroy, my_post)
      expect(subject).not_to be_able_to(:create, other_user_post)
      expect(subject).to be_able_to(:read, other_user_post)
      expect(subject).not_to be_able_to(:update, other_user_post)
      expect(subject).not_to be_able_to(:read, deleted_post)
      expect(subject).not_to be_able_to(:update, deleted_post)
      expect(subject).not_to be_able_to(:destroy, other_user_post)

      # Reply abilities
      expect(subject).to be_able_to(:create, my_reply)
      expect(subject).to be_able_to(:read, my_reply)
      expect(subject).to be_able_to(:update, my_reply)
      expect(subject).to be_able_to(:destroy, my_reply)
      expect(subject).not_to be_able_to(:create, other_user_reply)
      expect(subject).to be_able_to(:read, other_user_reply)
      expect(subject).not_to be_able_to(:update, other_user_reply)
      expect(subject).not_to be_able_to(:read, deleted_reply)
      expect(subject).not_to be_able_to(:update, deleted_reply)
      expect(subject).not_to be_able_to(:destroy, other_user_reply)

      # User abilities
      expect(subject).not_to be_able_to(:create, user)
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
      expect(subject).not_to be_able_to(:create, other_user)
      expect(subject).to be_able_to(:read, other_user)
      expect(subject).not_to be_able_to(:update, other_user)
      expect(subject).not_to be_able_to(:read, deactivated_user)
      expect(subject).not_to be_able_to(:update, deactivated_user)
      expect(subject).not_to be_able_to(:destroy, other_user)
    end
  end

  describe 'New' do
    let(:user) { User.new }
    let(:new_user) { true }

    it do
      # Post abilities
      expect(subject).not_to be_able_to(:create, my_post)
      expect(subject).not_to be_able_to(:update, my_post)
      expect(subject).not_to be_able_to(:destroy, my_post)
      expect(subject).to be_able_to(:read, other_user_post)
      expect(subject).not_to be_able_to(:update, other_user_post)
      expect(subject).not_to be_able_to(:read, deleted_post)

      # Reply abilities
      expect(subject).not_to be_able_to(:create, my_reply)
      expect(subject).not_to be_able_to(:update, my_reply)
      expect(subject).not_to be_able_to(:destroy, my_reply)
      expect(subject).to be_able_to(:read, other_user_reply)
      expect(subject).not_to be_able_to(:update, other_user_reply)
      expect(subject).not_to be_able_to(:read, deleted_reply)

      # Reply abilities
      expect(subject).to be_able_to(:create, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
      expect(subject).to be_able_to(:read, other_user)
      expect(subject).not_to be_able_to(:update, other_user)
      expect(subject).not_to be_able_to(:read, deactivated_user)
    end
  end
end