require 'rails_helper'

feature 'user views list of TV shows', %Q{
  As a site visitor
  I want to view a list of people's favorite TV shows
  So I can find new shows to watch
} do

  # Acceptance Criteria:
  # * I can see a list of all the TV shows

  scenario 'user views TV shows' do
    shows = []
    show_attrs = [
      { title: 'Game of Thrones', network: 'HBO' },
      { title: 'Orphan Black', network: 'BBC America' }
    ]

    show_attrs.each do |attrs|
      shows << TelevisionShow.create(attrs)
    end

    visit '/television_shows'
    shows.each do |show|
      expect(page).to have_content show.title
      expect(page).to have_content show.network
    end
  end
end
