#require './credentials'
require 'stringex'
require 'time'
require 'rack/google_analytics'

# Custom Config
DATA_EXT = ".yml" # Should be JSON if easier
API_PREFIX = "/api/v1"
GOOGLE_ANALYTICS = "UA-0000000-1"

# Paths
set :css_dir, 'public/css'
set :js_dir, 'public/js'
set :images_dir, 'public/images'

use Rack::GoogleAnalytics,
  :web_property_id => GOOGLE_ANALYTICS

Dir["data/*"].each do |path|
    name = File.basename path, DATA_EXT
    proxy "#{API_PREFIX}/#{name}.json", "api.json",
      :locals => { :collection => name }
end

helpers do
  def markdown(data)
    Tilt['md'].new { data }.render
  end
  def api(page)
    "#{API_PREFIX}/#{page}.json"
  end
end

# Middleman Plugins
activate :livereload
activate :minify_html

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method   = :rsync
#  deploy.user     = DEPLOY_USER
#  deploy.host     = DEPLOY_HOST
#  deploy.path     = DEPLOY_PATH
end
