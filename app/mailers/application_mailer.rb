# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Nnutrition@mail.com'
  layout 'mailer'
end
