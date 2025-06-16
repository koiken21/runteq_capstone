class ApplicationMailer < ActionMailer::Base
  # The default sender address is configured via the MAIL_FROM environment
  # variable so that it can be shared across different deployment environments.
  default from: ENV.fetch("MAIL_FROM", "from@example.com")
  layout "mailer"
end
