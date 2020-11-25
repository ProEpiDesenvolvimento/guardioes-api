class GroupManagerMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'
  
    def reset_password_email(group_manager)
      @group_manager = group_manager
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = group_manager.name + ' <' + group_manager.email + '>'
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  