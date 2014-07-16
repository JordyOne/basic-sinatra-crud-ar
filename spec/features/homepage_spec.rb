require "spec_helper.rb"

feature "homepage" do
  scenario "should have a button" do
    visit "/"
    expect(page).to have_content("Register")
  end
end
feature "registration_form" do
  scenario "links to registration form" do
    visit "/"
    click_link("Register")
    expect(page).to have_content("username")
  end
end

feature "Login" do
  scenario "allows user to login" do
    visit "/registration/new"

    fill_in "username", :with => "pgrunde"
    fill_in "password", :with => "drowssap"

    click_button "Register"

    visit "/"

      fill_in "username", :with => "pgrunde"
      fill_in "password", :with => "drowssap"

      click_button "Login"

      expect(page).to have_content("Welcome, pgrunde")

    end
end