SITE_CREDENTIALS = begin
  creds_path = "#{Rails.root.to_s}/config/site_credentials.yml"
  if File.exist?(creds_path)
    YAML.load_file creds_path
  else
    {
      yahoo: {
        username: ENV['YAHOO_USERNAME'],
        password: ENV['YAHOO_PASSWORD']
      }
    }
  end
end