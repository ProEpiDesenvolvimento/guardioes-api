require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.action_mailer.default_url_options = { host: ENV['MAILER_URL'] }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths += %W(#{config.root}/app/policies #{config.root}/app/roles)

    # Index names are now:
    # classname_environment[if survey user has group, _groupmanagergroupname]
    # It has been overriden searchkick's class that sends data to elaticsearch, 
    # such that the index name is now defined by the model that is being 
    # evaluated using the function 'index_pattern_name'
    Searchkick::RecordData.class_eval do
      def record_data
        index_name = index.name
        if record.class.method_defined?(:index_pattern_name)
          index_name = record.index_pattern_name
        end
        data = {
          _index: index_name,
          _id: search_id
        }
        data[:_type] = document_type if Searchkick.server_below7?
        data[:routing] = record.search_routing if record.respond_to?(:search_routing)
        data
      end
    end
  end
end
