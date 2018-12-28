require 'rails_helper'

RSpec.describe 'Requesting a sub' do
  it 'works' do
    asking_dj = create :dj, :grandfathered_in
    fulfilling_dj = create :dj, :grandfathered_in
    show = create :freeform_show, dj: asking_dj
    episode = show.episodes.first

    sign_in asking_dj
    click_on 'Sub Board'
    click_on 'request a sub'

    find('[title="Request Sub"]', match: :first).click

    fill_in 'Reason', with: 'I have to wash my hair'
    find('[value="Choose DJs to whom you want to limit this request."]')
      .click
    page.driver.browser.action.send_keys(fulfilling_dj.name)
        .send_keys(:enter).perform
    click_on 'Place the request'

    expect_email to: fulfilling_dj.email, matching: /#{asking_dj} needs a sub/

    Capybara.using_session :other do
      sign_in fulfilling_dj
      click_on 'Sub Board'
      click_on show.unambiguous_name

      expect(page).to have_content 'I have to wash my hair'
      click_on 'Cover for this slot'

      expect_email to: asking_dj.email,
                   cc: fulfilling_dj.email,
                   matching: /You were bailed out by #{fulfilling_dj}/
    end
  end

  private

  def expect_email(to:, cc: nil, matching:)
    email = ActionMailer::Base.deliveries.last

    expect(email.to.first).to eq to
    expect(email.cc.first).to eq cc unless cc.blank?
    expect(email.text_part.body.to_s).to match matching
    expect(email.html_part.body.to_s).to match matching
  end
end
