require 'spec_helper'

feature "User views recipes index page" do
  scenario "user sees all the recipes" do
    visit '/recipes'

    expect(page).to have_content "Grilled Bacon-Wrapped Stuffed Hot Dogs"
    expect(page).to have_content "Orange Cornmeal Cake"
    expect(page).to have_content "Vermont Maple Syrup Pork Chops"
  end
end
