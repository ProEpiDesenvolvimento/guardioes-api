class GroupManagerTeamMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def reset_password_email(group_manager_team)
    @group_manager_team = group_manager_team
    email = mail()
    email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
    email.to = group_manager_team.name + ' <' + group_manager_team.email + '>'
    email.subject = '[Guardiões da Saúde] Redefinir Senha'
    return email
  end
end
