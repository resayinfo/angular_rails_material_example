require "spec_helper"

describe "Posts", :js do
  let(:new_post_name){ 'Updated Post!' }
  it 'works!' do
    # make some data
    luke = create_luke_skywalker
    create_bill_murray
    create_a_league_post user: luke

    # regular user story
    visit posts_path
    log_in_as 'Bill', 'Murray'
    show_a_post_from_the_index
    expect_not_to_see_the_delete_post_button
    expect_not_to_be_able_to_modify_the_post

    visit posts_path
    click_link "New Post"
    create_a_post 'Created Post!'
    delete_the_post

    visit posts_path
    click_link "New Post"
    create_a_post 'Created Post!'
    update_the_post new_post_name

    visit posts_path
    expect_not_to_see_the_deleted_post new_post_name

    # new user story
    log_out
    expect_not_to_see_the_create_post_button
    expect_not_to_see_the_deleted_post 'Created Post!'
    post = create_a_league_post
    search_for_a_post post
    show_a_post_from_the_index
    expect_not_to_see_the_delete_post_button
    expect_not_to_be_able_to_modify_the_post
  end
end