class CreateContentJob < ApplicationJob
  queue_as :default

  def perform(content_params)
    puts content_params
    content = Content.new(content_params)
    puts content.app_id
    content.save!
  end
end
