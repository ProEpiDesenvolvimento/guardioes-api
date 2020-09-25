class VigilanceMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def covid_vigilance_email(survey, user)
    @survey = survey
    
    if user.group_id
      group_manager = user.group.group_manager

      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = group_manager.group_name + ' <' + group_manager.vigilance_email + '>'
      email.subject = '[VIGILANCIA ATIVA] Novo usuário com suspeita'

      return email
    end
  end
end
  