require "spec_helper"

describe "Logging in and out", :js do
  it "works" do
    create_luke_skywalker
    visit root_path
    log_in_as 'Luke'
    log_out
  end
end