require 'acceptance_helper'

feature 'create question', :js do
  given(:user) { create(:user) }

  context "as user" do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'creates qustion with valid params', :aggregate_failures do
      page.find("#add_question_btn").trigger('click')

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test text'
      click_on 'Save'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test text'
    end

    scenario 'can not create question with invalid params' do
      page.find("#add_question_btn").trigger('click')

      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Save'

      expect(page).to have_content 'Title can\'t be blank '
      expect(page).to have_content 'Body can\'t be blank '
    end
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        page.find("#add_question_btn").trigger('click')

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Save'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end  

  context "as guest" do
    xscenario 'can not create question', :visual do
      visit questions_path
      expect(page).to match_reference_screenshot
    end
  end
end
