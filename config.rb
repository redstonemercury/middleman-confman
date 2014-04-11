require './credentials'
require 'stringex'
require 'time'

# Custom Config
DATA_EXT = ".yml"
API_PREFIX = "/api"

activate :livereload

set :css_dir, 'public/css'

set :js_dir, 'public/js'

set :images_dir, 'public/images'

Dir["data/*"].each do |path|
    name = File.basename path, DATA_EXT
    proxy "#{API_PREFIX}/#{name}.json", "api.json",
      :locals => { :collection => name }
end

helpers do
  def markdown(data)
    Tilt['md'].new { data }.render 
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method   = :rsync
  deploy.user     = WEBBOX_USER
  deploy.host     = WEBBOX_HOST
  deploy.path     = WEBBOX_PATH
end
