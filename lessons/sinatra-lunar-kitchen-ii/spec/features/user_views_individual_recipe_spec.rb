require 'spec_helper'

feature "User views a recipe" do
  scenario "user the basic recipe information" do
    visit '/recipes/556'

    title = "Rosemary Duck with Apricots"
    description = "does this recipe work with ducks you shoot, or that you buy in a grocery store?"
    instructions = "Method 1 Combine the rosemary, brown sugar, black pepper, and salt."

    expect(page).to have_content title
    expect(page).to have_content description
    expect(page).to have_content instructions
  end

  scenario "user views a recipe without a description" do
    visit '/recipes/403'

    expect(page).to have_content "This recipe doesn't have a description."
  end

  scenario "user views a recipe without any instructions" do
    visit '/recipes/403'

    expect(page).to have_content "This recipe doesn't have any instructions."
  end

  scenario "user views a recipe's ingredients" do
    visit '/recipes/508'

    ingredients = [
      '1 lb fresh brussels sprouts',
      '4-6 Tbsp butter',
      '1/2 onion, chopped',
      'Salt and Pepper',
      '1 teaspoon lemon juice or 1 Tbsp Meyer lemon juice, fresh squeezed',
      '1/4 cup toasted slivered almonds'
    ]

    ingredients.each do |ingredient|
      expect(page).to have_content ingredient
    end
  end
end
