class UserMailer < ApplicationMailer
  def registration_email(user, initial_password)
    @user = user
    @initial_password = initial_password
    @url = complete_registration_url(token: user.registration_token)
    mail(to: @user.mail_address, subject: 'Complete your registration')
  end

  private

  def complete_registration_url(token:)
    "http://example.com/users/complete_registration?token=#{token}"
  end
end
