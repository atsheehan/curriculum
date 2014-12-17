require 'rails_helper'

feature 'user adds a new TV show', %Q{
  As a site visitor
  I want to add one of my favorite shows
  So that I can encourage others to binge watch it
} do

  # Acceptance Criteria:
  # * I must provide the show's title.
  # * I can optionally provide the show's network, the years it ran,
  # and a synopsis.

  scenario 'user adds a new TV show' do
    attrs = {
      title: 'Game of Thrones',
      network: 'HBO',
      years: '2011-',
      synopsis: 'Seven noble families fight for control of the mythical land of Westeros.'
    }

    show = TelevisionShow.new(attrs)

    visit '/television_shows/new'
    fill_in 'Title', with: show.title
    fill_in 'Network', with: show.network
    fill_in 'Years', with: show.years
    fill_in 'Synopsis', with: show.synopsis
    click_on 'Submit'

    expect(page).to have_content 'Success'
    expect(page).to have_content show.title
    expect(page).to_not have_content show.synopsis
  end

  scenario 'without required attributes' do
    visit '/television_shows/new'
    click_on 'Submit'

    expect(page).to_not have_content 'Success'
    expect(page).to have_content "can't be blank"
  end

  scenario 'user cannot add a show that is already in the database' do
    attrs = {
      title: 'Game of Thrones',
      network: 'HBO'
    }

    show = TelevisionShow.create(attrs)

    visit '/television_shows/new'
    fill_in 'Title', with: show.title
    fill_in 'Network', with: show.network
    click_on 'Submit'

    expect(page).to_not have_content 'Success'
    expect(page).to have_content "has already been taken"
  end
end
