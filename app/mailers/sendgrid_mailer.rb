# frozen_string_literal: true

class SendgridMailer
    def self.send(to, subsitutions, template_id)
      data = {
        "personalizations": [
          {
            "to": [
              {
                "email": to
              }
            ],
            "dynamic_template_data": subsitutions
          }
        ],
        "from": {
          "email": "repaytech@gmail.com",
          "name": "Repay"
        },
        "template_id": template_id
      }
      sg = SendGrid::API.new(api_key: Rails.application.credentials.sendgrid)
      begin
        response = sg.client.mail._("send").post(request_body: data)
        return response.status_code
      rescue Exception => e
        puts e.message
      end
    end
  end
  