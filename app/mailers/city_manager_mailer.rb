class CityManagerMailer < ActionMailer::Base
    default from: 'proepi.desenvolvimento@gmail.com'
    layout 'mailer'

    def reset_password_email(city_manager)
      @city_manager = city_manager
      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = city_manager.name + ' <' + city_manager.email + '>'
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
end
