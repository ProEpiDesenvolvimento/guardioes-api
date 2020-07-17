class UserMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def reset_password_email(user)
    @user = user
    email = mail()
    email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
    email.to = user.user_name + ' <' + user.email + '>'
    email.subject = '[Guardiões da Saúde] Redefinir Senha'
    return email
  end
end
