GCM_Config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'gcm.yml'))[Rails.env]

configatron.gcm_on_rails.api_url = GCM_Config['api_url']
configatron.gcm_on_rails.api_key = GCM_Config['api_key']
configatron.gcm_on_rails.app_name = GCM_Config['app_name']
configatron.gcm_on_rails.delivery_format = GCM_Config['delivery_format']