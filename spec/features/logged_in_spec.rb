require "spec_helper.rb"

feature "logged in user" do
  scenario "should have a logout button" do
    visit "/"


    fill_in "username", :with => "pgrunde"
    fill_in "password", :with => "drowssap"

    click_button "Login"


    expect(page).to have_content("Logout")
  end
end