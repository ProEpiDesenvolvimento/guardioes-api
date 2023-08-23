class UserMailer < ActionMailer::Base
  default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
  layout 'mailer'

  def reset_password_email(user)
    @user = user
    email = mail()
    email.to = "#{user.user_name} <#{user.email}>"
    email.subject = '[Guardiões da Saúde] Redefinir Senha'
    return email
  end

  def request_deletion_email(user)
    @user = user
    email = mail()
    email.to = "#{user.user_name} <#{user.email}>, ProEpi <#{ENV['MAILER_EMAIL']}>"
    email.subject = '[Guardiões da Saúde] Excluir Conta'
    return email
  end
end
