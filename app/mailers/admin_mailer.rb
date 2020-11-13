class AdminMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'
  
    def reset_password_email(admin)
      @admin = admin
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = admin.first_name + ' <' + admin.email + '>'
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  