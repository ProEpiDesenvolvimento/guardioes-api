class GroupManagerTeamMailer < ActionMailer::Base
  default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
  layout 'mailer'

  def reset_password_email(group_manager_team)
    @group_manager_team = group_manager_team
    email = mail()
    email.to = "#{group_manager_team.name} <#{group_manager_team.email}>"
    email.subject = '[Guardiões da Saúde] Redefinir Senha'
    return email
  end
end
