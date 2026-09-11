# rails_blob_url / rails_representation_url need a host to build absolute
# URLs when not called from inside a request (and controllers pass
# `host: request.base_url` explicitly anyway) -- this covers any usage
# outside a request context (jobs, console) and gives Action Mailer-style
# default_url_options for free if we ever add mailers.
if ENV["APP_HOST"].present?
  Rails.application.routes.default_url_options[:host] = ENV["APP_HOST"]
  Rails.application.routes.default_url_options[:protocol] = ENV.fetch("APP_PROTOCOL", "https")
end
