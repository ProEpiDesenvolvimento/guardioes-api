class DeviseCustomMailer < Devise::Mailer
    include Devise::Controllers::UrlHelpers
  
    def confirmation_instructions(resource, token, _options = {})
      confirmation_path = ENV["WEB_HOST"] + '/user/confirmation/' + resource.confirmation_token
      
      SendgridMailer.send(
        resource.unconfirmed_email ? resource.unconfirmed_email : resource.email,
        { "confirmAccountUrl": confirmation_path },
        "d-6c95b4755a2a4aabae5291ab9695c49b"
      )
    end

    def reset_password_instructions(resource, token, _options = {})
        reset_path = 'gds://password/' + resource.reset_password_token
      
        SendgridMailer.send(
            resource.email,
            { "Url": reset_path },
            "d-6c95b4755a2a4aabae5291ab9695c49b"
        )
    end

  end