require "spec_helper.rb"

# As an anonymous person, I can fill out the
# registration form to create an account

# When submitting the form, I should
# see "Thank you for registering"
#
# This message should go away when I refresh
# the page.

feature "#registration" do
  scenario "successful registration upon submit" do
    visit "/registration/new"

    fill_in "username", :with => "pgrunde"
    fill_in "password", :with => "drowssap"

    click_button "Register"

    expect(page).to have_content("Thank you for registering")

    #unsuccesful registration

    visit "/registration/new"

    fill_in "username", :with => ""
    click_button "Register"

    expect(page).to have_content("Please fill in all fields")

    visit "/registration/new"

    fill_in "password", :with => ""
    click_button "Register"

    expect(page).to have_content("Please fill in all fields")
  end
end

#login username already exists
feature "#registration_2" do
  scenario "username already exists" do
    visit "/"

    click_link "Register"

    fill_in "username", with: "jess"
    fill_in "password", with: "password"

    click_button "Register"
    expect(page).to have_content("Thank you for registering Register Username Password")

    click_link "Register"

    fill_in "username", with: "jess"
    fill_in "password", with: "password"

    click_button "Register"

    expect(page).to have_content("That username is already taken")

  end
end