class NewsletterMailer < ApplicationMailer
  def send_newsletter(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to our newsletter!')
  end
end
