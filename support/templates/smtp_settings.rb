require 'cgi'
require 'uri'

if Rails.env.production? && ENV['SMTP_URL']
	Gitlab::Application.config.action_mailer.delivery_method = :smtp

	begin
		uri = URI.parse(ENV['SMTP_URL'])
		params = uri.query ? CGI::parse(uri.query) : {}
		domain = params['domain'] ? params['domain'][0] : nil
		guessed_domain = uri.host.include?('.') ? uri.host.split('.')[-2..-1].join('.') : uri.host
	rescue URI::InvalidURIError
		raise "Invalid SMTP_URL: #{ENV['SMTP_URL']}"
	end

	ActionMailer::Base.smtp_settings = {
		address: uri.host,
		port: uri.port || 465,
		user_name: uri.user,
		password: uri.password,
		domain: domain || guessed_domain,
		authentication: :login,
		tls: true
	}
end
