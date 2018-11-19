# frozen_string_literal: true

module System
  def sign_in(dj)
    visit session_path dj
    fill_in 'Email', with: dj.email
    fill_in 'Password', with: dj.password
    click_on 'Sign In'
  end

  private

  def session_path(model)
    name = model.class.name.downcase
    send(:"new_#{name}_session_path")
  end
end
