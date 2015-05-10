require'spec_helper'

describe 'User' do
  let(:user) { create_bill_murray }

  # testing validations
  it { expect(user).to validate_presence_of :password }
  it { expect(user).to validate_uniqueness_of(:username) }
  it { expect(user).to allow_value('thedude123').for(:username) }
  it { expect(user).not_to allow_value('thedude@123.com').for(:username) }
  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(user).to allow_value('thedude@123.com').for(:email) }
  it { expect(user).not_to allow_value('thedude123').for(:email) }
end