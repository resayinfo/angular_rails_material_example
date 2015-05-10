require 'spec_helper'

describe 'Reply' do
  let(:reply_params){ {} }
  let(:reply){ Reply.new reply_params }

  describe 'validations' do
    it { expect(reply).to validate_presence_of :body }
    it { expect(reply).to validate_presence_of :user_id }
    it { expect(reply).to validate_presence_of :post_id }
  end
end