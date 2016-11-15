require 'thor'
require 'open-uri'

$repo='https://raw.githubusercontent.com/aleksandrov1988/rails5_app_templates/master'

def get_file(path, options={})

  full_url=options[:url] || file_url(options[:path] || path)
  file path, open(full_url).read
end

def get_font(name)
  get_file "vendor/assets/fonts/#{name}"
end


def file_url(name, base_url=$repo)
  "#{base_url}/files/#{name}"
end


# Баг в Thor. binread всегда считывает US-ASCII
File.instance_eval do
  def binread(file)
    File.open(file, "rb:#{Encoding.default_external.to_s}") { |f| f.read }
  end
end


gem 'rails-i18n'
insert_into_file 'config/application.rb', after: /^\s*class\s+Application.+$/ do
  <<BASIC_APP_INSTALL


  config.i18n.default_locale = :ru
  config.eager_load_paths << Rails.root.join("lib")
  ActiveRecord::Base.belongs_to_required_by_default = true
BASIC_APP_INSTALL
end
get_file 'config/locales/ru.yml'

get_font('intro.woff')
get_font('open_sans.woff')
%w(bold italic light).each { |x| get_font("open_sans_#{x}.woff") }
get_font('ubuntu_mono.woff')
get_font('ubuntu_mono_bold.woff')
get_font('ubuntu_mono_italic.woff')
%w(bold-italic bold italic light-italic light regular).each{|x| get_font("roboto-#{x}.woff2")}

get_file 'vendor/assets/stylesheets/fonts.scss'


get_file 'config/initializers/time_zone.rb'


gem 'haml-rails'

gem_group :development, :test do
  gem "rspec-rails"
end

gem_group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-chruby'
  gem 'capistrano3-puma'
end

add_source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end




#Twitter Bootstrap
gem 'bootstrap'
gem 'bootstrap_form'
gem 'ru_propisju'

run 'bundle install'

#routes
generate('controller', 'welcome', 'index')
route "root 'welcome#index'"


insert_into_file 'app/assets/javascripts/application.js', before: /^\s*\/\/=\s*require_tree\s+\./ do
  <<APPJS

  //= require tether
  //= require bootstrap-sprockets

APPJS
end

get_file 'app/assets/stylesheets/bootstrap-variables.scss'
get_file 'app/assets/stylesheets/theme.scss'
get_file 'app/assets/stylesheets/application.scss'
get_file 'app/assets/stylesheets/main.scss'
run 'rm app/assets/stylesheets/application.css'


#Font Awesome
gem 'font-awesome-rails'


#layout and helpers
run 'rm app/views/layouts/application.html.erb'

get_file('app/views/layouts/application.html.haml')
get_file('app/views/application/_navbar.html.haml')
get_file('app/views/application/error.html.haml')
get_file('app/views/application/_error.html.haml')
get_file('app/views/application/_footer.html.haml')
get_file('config/initializers/active_model_translation.rb')

%w(apple-icon.png favicon-32x32.png favicon.ico mephi_logo_small_white.png).each do |name|
  get_file("app/assets/images/#{name}")
end


get_file('app/helpers/copyright_helper.rb')


get_file('config/initializers/form_builder.rb')
get_file('app/helpers/error_messages_helper.rb')
get_file('app/views/application/_error_messages_for.html.haml')
get_file('app/views/application/_error_messages_for_attr.html.haml')



# get_file 'vendor/assets/javascripts/bootstrap-notify.min.js'
# get_file 'app/assets/javascripts/growl_messages.coffee'
get_file 'app/views/application/_flash.html.haml'
# get_file 'app/views/application/_flash.html.haml', path: 'app/views/application/_flash_messages_growl.html.haml'
# insert_into_file 'app/assets/javascripts/application.js', "//= require bootstrap-notify.min\n", before: /^\s*\/\/=\s*require_tree\s+\./



gem 'rack-cas', github: 'aleksandrov1988/rack-cas'
gem 'addressable', github: 'aleksandrov1988/addressable'
run 'bundle install'
insert_into_file 'config/application.rb', "\nrequire 'rack-cas/session_store/active_record'\n",
:after => /^\s*require\s*'rails\/all'\s*$/
insert_into_file 'config/application.rb', :before => /^\s*end\s*\n\s*end\s*\z/ do
  <<DATA


  config.rack_cas.session_store = RackCAS::ActiveRecordStore
  config.rack_cas.server_url='https://auth.mephi.ru'
  config.rack_cas.exclude_path='/api'

DATA
end
get_file 'config/initializers/session_store.rb'
generate 'cas_session_store_migration'


get_file 'app/controllers/application_controller.rb'
get_file 'app/helpers/application_helper.rb'


gem 'strip_attributes'


gem 'kaminari'
run 'bundle install'
generate "kaminari:views bootstrap4 -e haml"


#Git

git :init
git :add => "."
git :commit => %Q{ -m 'Initial commit' }


run 'bundle install'
