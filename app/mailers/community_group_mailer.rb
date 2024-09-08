class CommunityGroupMailer < ActionMailer::Base
  default from: "ProEpi <#{ENV['MAILER_EMAIL']}>"
  layout 'mailer'

  def new_signal_email(community_group, event_data)
    @community_group = community_group
    @event_data = event_data
    email = mail()
    email.to = "#{community_group.name} <#{community_group.email1}>"
    email.subject = '[GdS Líderes] Novo sinal de alerta'
    return email
  end
end
