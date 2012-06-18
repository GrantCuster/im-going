ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "goings.im@gmail.com",
  :password             => "yamahadinosaur",
  :authentication       => "plain",
  :enable_starttls_auto => true
}