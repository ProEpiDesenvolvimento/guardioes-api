def user_for_field_nill
  return User.new(
    :user_name => "",
    :email => "",
    :password => "",
    :app_id => 1
  )
end

class UserMailer < ActionMailer::Base
default from: 'proepi.desenvolvimento@gmail.com'
layout 'mailer'

def reset_password_email(user)
  if user == nil
    @user = user_for_field_nill()
    email = mail()
    email.subject = "Campo inválido, informe um usuário"
    return email
  end
  else
    @user = user
    email = mail()
    if user.user_name == nil || user.email == nil
      email.subject = "Usuário inválido"
      return email
    end
    email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
    email.to = user.user_name + ' <' + user.email + '>'
    email.subject = '[Guardiões da Saúde] Redefinir Senha'
    return email
end
end
