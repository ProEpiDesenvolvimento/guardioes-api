class CityManagerMailer < ActionMailer::Base
    default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
    layout 'mailer'

    def reset_password_email(city_manager)
      @city_manager = city_manager
      email = mail()
      email.to = "#{city_manager.name} <#{city_manager.email}>"
      email.subject = '[Guardiões da Saúde] Redefinir Senha'
      return email
    end
end
