module CucumberHelpers
  def log_in_as(username, password='Skywalker')
    click_link 'Login/Register'
    fill_in :inputUsername, with: username
    fill_in :inputPassword, with: password
    click_button "Login"
    expect_to_be_logged_in
  end

  # Borrowed from http://stackoverflow.com/questions/12771436/how-to-test-a-select2-element-with-capybara-dsl/28970538#28970538
  def select2(value, attrs)
    s2c = find("#s2id_#{attrs[:from]}", count: 1)
    (s2c.first(".select2-choice") || s2c.find(".select2-choices")).click

    find(:xpath, "//body").all("input.select2-input")[-1].set(value)
    page.execute_script(%|$("input.select2-input:visible").keyup();|)
    drop_container = ".select2-results"
    find(:xpath, "//body").all("#{drop_container} li", text: value)[-1].click
  end

  def expect_to_be_logged_in
    expect(page).to have_link('Logout', visible: false)
    expect_and_close_flash('Successfully logged in as ')
  end

  def log_out
    click_link 'Hello, '
    click_link "Logout"
    expect(page).to have_link 'Login/Register'
    expect_and_close_flash('Successfully logged out')
  end

  def show_a_post_from_the_index
    sleep 1 # TODO: get rid of this sleep...
    find('table.posts-table tr.outer-row', count: 1).click
    find('a.show-link').click
    expect(find('form legend')).to have_text('Post ')
  end

  def search_for_a_post(post)
    league = post.league

    within "#search-form" do
      fill_in "search-input", with: post.title[1..-2]
      select2 'Football', from: "league-select"
      select2 "'Url' Like", from: "filter-select"
      within '#filter-value-string-input' do
        find('.search-value-input').set league.url[1..-2]
        find(".ok-value-button").click
      end
      select2 "'Teams' Greater Than", from: "filter-select"
      within '#filter-value-integer-input' do
        find('.search-value-input').set (league.teams - 1).to_s
        find(".ok-value-button").click
      end
      select2 "'Fractional Points' Equals", from: "filter-select"
      within '#filter-value-boolean-input' do
        select league.fractional_points.to_s
        find(".ok-value-button").click
      end
      select2 "'Points Per Rushing Td' Equals", from: "filter-select"
      within '#filter-value-decimal-input' do
        find('.search-value-input').set league.points_per_rushing_td.to_s
        find(".ok-value-button").click
      end
      select2 "'Draft Date' Less Than", from: "filter-select"
      within '#filter-value-datetime-input' do
        find('.search-value-input').set league.draft_date.tomorrow.strftime("%m/%d/%y")
        find(".ok-value-button").click
      end
      select2 'Teams Filled', from: "order-select"
      fill_in "limit-input", with: '1'
    end

    sleep 0.6 # allow debounce to kick in when fetching posts
    expect(find("#posts-view")).to have_css("table.posts-table tr.outer-row", count: 1)
  end

  def expect_not_to_see_the_delete_post_button
    expect(page).not_to have_button('Delete')
  end

  def expect_not_to_be_able_to_modify_the_post
    expect(find_field(:title, disabled: true)).to be_present
    expect(page).not_to have_button('Update')
  end

  def create_a_post(title)
    fill_in :title, with: title
    select :Hockey, from: :leagueType
    click_button "Add"
    expect_and_close_flash "Successfully created post #"
    expect(find('form legend')).to have_text('Post ')
    expect(page).to have_field(:title, with: title)
  end

  def delete_the_post
    click_button "Delete"
    expect_and_close_flash 'Successfully deleted post #'
  end

  def update_the_post(title)
    fill_in :title, with: title
    click_button "Update"
    expect_and_close_flash "Successfully updated post #"
    expect(page).to have_field(:title, with: title)
  end

  def expect_not_to_see_the_deleted_post(title)
    expect(page).not_to have_text(title)
  end

  def expect_not_to_see_the_create_post_button
    expect(page).not_to have_button('Create')
  end

  def expect_and_close_flash(message)
    expect(find('#flash-messages')).to have_text(message)
    first('#flash-messages button.close').click
  end

  def visit_an_account_page
    user = create_bill_murray
    visit user_path user
    expect(find('form legend')).to have_text(user.username)
  end

  def expect_not_to_see_the_deactivate_user_button
    expect(page).not_to have_button('Deactivate')
  end

  def expect_not_to_be_able_to_modify_the_user
    expect(find_field(:username, disabled: true)).to be_present
    expect(page).not_to have_button('Update')
  end

  def click_the_new_account_link
    click_link 'Login/Register'
    click_link 'New Account'
    expect(find('form legend')).to have_text('Create User')
  end

  def create_a_user(username)
    fill_in :username, with: username
    fill_in :email, with: "#{username}@test.com"
    fill_in :password, with: 'password'
    fill_in :passwordConfirmation, with: 'password'
    click_button "Register"
    expect_and_close_flash "Successfully created account for #{username}"
    expect(find('form legend')).to have_text("#{username}'s Account")
    expect(page).to have_field(:username, with: username)
  end

  def expect_not_to_be_able_to_modify_the_users_authorization
    expect(find_field('admin-radio', disabled: true)).to be_present
    expect(find_field('normal-radio', disabled: true)).to be_present
  end

  def update_the_user(username, **options)
    fill_in :username, with: username

    if password = options[:password]
      fill_in :password, with: password
      fill_in :passwordConfirmation, with: password
    end

    unless options[:admin].nil?
      choice = options[:admin] ? 'admin-radio' : 'normal-radio'
      choose choice
    end

    click_button "Update"
    expect_and_close_flash "Successfully updated #{username}"
    expect(page).to have_field(:username, with: username)
  end

  def deactivate_the_user
    click_button "Deactivate"
    expect_and_close_flash "Successfully deactivated "
  end

  def activate_the_user
    click_button "Activate"
    expect_and_close_flash "Successfully activated "
  end
end