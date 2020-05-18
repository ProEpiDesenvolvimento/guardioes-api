class DeviseCustomMailer < Devise::Mailer
    include Devise::Controllers::UrlHelpers
  
    def confirmation_instructions(resource, token, _options = {})
      confirmation_path = ENV["WEB_HOST"] + '/user/confirmation/' + resource.confirmation_token
      
      SendgridMailer.send(
        resource.unconfirmed_email ? resource.unconfirmed_email : resource.email,
        { "confirmAccountUrl": confirmation_path },
        ""
      )
    end

    def reset_password_instructions(resource, token, _options = {})
        reset_path = 'gds://password/' + resource.reset_password_token
        puts reset_path
        SendgridMailer.send(
            resource.email,
            { 
              "code": resource.aux_code,
              "reset_token": resource.reset_password_token
            },
            "d-19452e288ce940868a08c4873bcd8311"
        )
    end

  end