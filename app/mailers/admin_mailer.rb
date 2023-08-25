class AdminMailer < ActionMailer::Base
    default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
    layout 'mailer'
  
    def reset_password_email(admin)
      @admin = admin
      email = mail()
      email.to = "#{admin.first_name} <#{admin.email}>"
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  