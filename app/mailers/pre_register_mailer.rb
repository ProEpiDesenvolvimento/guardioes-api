class PreRegisterMailer < ActionMailer::Base
    default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
    layout 'mailer'
  
    def analyze_email(pre_register)
      @pre_register = pre_register
      email = mail()
      email.to = 'Comunicação <comunica.proepi@gmail.com>'
      email.subject = '[Guardiões da Saúde] Solicitação de cadastro de instituição de ensino'
      return email
    end
  end
  