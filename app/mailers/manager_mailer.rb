class ManagerMailer < ActionMailer::Base
    default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
    layout 'mailer'
  
    def reset_password_email(manager)
      @manager = manager
      email = mail()
      email.to = "#{manager.name} <#{manager.email}>"
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  