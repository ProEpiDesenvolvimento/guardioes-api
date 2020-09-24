class VigilanceMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def covid_vigilance_email(survey, user)
    @survey = survey
    
    if user.group
      group_manager = GroupManager.find_by_id(Group.find_by_id(user.group_id).id).vigilance_email
      
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = group_manager.group_name + ' <' + grou_manager.vigilance_email + '>'
      email.subject = '[VIGILANCIA ATIVA] Novo usuário com suspeita'
      
      return email
    end
  end
end
  