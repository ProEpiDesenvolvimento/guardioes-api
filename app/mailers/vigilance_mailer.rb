class VigilanceMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'
  
    def covid_vigilance_email(survey)
      @survey = survey
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = 'gabriel <gsmartins96.x@gmail.com>'
      email.subject = '[VIGILANCIA ATIVA] Novo usuário com suspeita'
      
      return email
    end
  end
  