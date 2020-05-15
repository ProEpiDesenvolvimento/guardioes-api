class DeviseCustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  # If there is an object in your application that returns a contact email, you can use it as follows
  # Note that Devise passes a Devise::Mailer object to your proc, hence the parameter throwaway (*).
  default from: ->(*) { Class.instance.email_address }
  
    def reset_password_instructions(resource, token, _options = {})
        reset_path = 'gds://password/' + resource.reset_password_token
      
        SendgridMailer.send(
            resource.email,
            { "Url": reset_path },
            "d-19452e288ce940868a08c4873bcd8311"
        )
    end

  end