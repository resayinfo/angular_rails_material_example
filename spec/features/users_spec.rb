require "spec_helper"

describe "Users", :js do
  it 'works!' do
    # new user story
    visit_an_account_page
    expect_not_to_see_the_deactivate_user_button
    expect_not_to_be_able_to_modify_the_user
    click_the_new_account_link
    create_a_user 'NewUser'
    expect_to_be_logged_in

    # regular user story
    expect_not_to_be_able_to_modify_the_users_authorization
    update_the_user 'UpdatedUser', password: 'CrazyNewPa$$w0rd'
    log_out

    # admin user story
    create_luke_skywalker
    log_in_as 'Luke'
    deactivate_the_user
    activate_the_user
    update_the_user 'AdminUser', admin: true
    log_out
    log_in_as 'AdminUser', 'CrazyNewPa$$w0rd'
    update_the_user 'AdminUser', admin: false
  end
end