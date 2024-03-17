class UserController < ApplicationController
  def subscribe
    @user = User.find_or_initialize_by(email: params[:email])

    unless @user.persisted?
      @user.save
      NewsletterMailer.send_newsletter(@user).deliver_now
    end

    redirect_to root_path, notice: 'Thank you for subscribing!'
  end
end
