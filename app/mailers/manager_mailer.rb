class ManagerMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'
  
    def reset_password_email(manager)
      @manager = manager
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = manager.name + ' <' + manager.email + '>'
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  