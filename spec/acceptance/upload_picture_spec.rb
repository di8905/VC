# frozen_string_literal: true
require "rails_helper"

feature "Upload picture", "
  As a guest I want to load my picture
  to the site's gallery
  in order to populate public meme collection
" do
  scenario "Guest uploads picture" do
    visit root_path
    click_on "Upload picture"
    attach_file("Upload picture:", "#{Rails.root}/public/500.html")
    click_on "Upload"

    expect(page).to have_css("img.picture")
  end

  scenario "Guest tries upload without file selected" do
    visit root_path
    click_on "Upload picture"
    click_on "Upload"

    expect(page).to have_content("File can't be blank")
  end
end
