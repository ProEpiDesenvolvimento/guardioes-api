class GroupManagerMailer < ActionMailer::Base
    default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
    layout 'mailer'
  
    def reset_password_email(group_manager)
      @group_manager = group_manager
      email = mail()
      email.to = "#{group_manager.name} <#{group_manager.email}>"
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
  end
  