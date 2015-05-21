class SignoffInstance < ActiveRecord::Base
  validate :signed_or_not_signed?
  belongs_to :signoff

  def signed_or_not_signed?
    if !signed.nil? && signed.blank?
      self.errors.add :signed, "You must type your name to sign off on the #{on}."
    end
  end
end
