class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: "mn.pfs.reg@gmail.com", "Precedence" => "bulk"
  default to: "mn.pfs.reg@gmail.com"
  # layout 'mailer'
end
