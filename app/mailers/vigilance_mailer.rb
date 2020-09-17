class VigilanceMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def covid_vigilance_email(survey, user)
    @survey = survey
    
    if user.school_unit_id
      school_unit = SchoolUnit.find(user.school_unit_id)
      recipient = school_unit.email
    end

    email = mail()
    email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
    email.to = school_unit.description + ' <' + recipient + '>'
    email.subject = '[VIGILANCIA ATIVA] Novo usuário com suspeita'
    
    return email
  end
end
  