class PreRegisterMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'
  
    def analyze_email(pre_register)
      @pre_register = pre_register
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = 'Comunicação <comunica.proepi@gmail.com>'
      email.subject = '[Guardiões da Saúde] Solicitação de cadastro de instituição de ensino'
      return email
    end
  end
  