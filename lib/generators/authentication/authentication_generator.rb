class AuthenticationGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def setup_rspec
    gem 'rspec-rails', :group => 'development'
    gem 'webrat', :group => 'development'

    gem 'rspec', :group => 'test'
    gem 'webrat', :group => 'test'
    gem 'factory_girl_rails', :group => 'test'

    empty_directory 'spec/'
    empty_directory 'spec/controllers'
    empty_directory 'spec/models'
    empty_directory 'spec/requests'

    copy_file "spec_helper.rb", "spec/spec_helper.rb"
  end

  def generate_authentication_tests
    copy_file "user_spec.rb", "spec/models/user_spec.rb"
    copy_file "users_controller_spec.rb", "spec/controllers/users_controller_spec.rb"
    copy_file "sessions_controller_spec.rb", "spec/controllers/sessions_controller_spec.rb"
    copy_file "users_spec.rb", "spec/requests/users_spec.rb"
    copy_file "factories.rb", "spec/factories.rb"
  end

  def generate_user_model
    copy_file "20110926214624_create_users.rb", "db/migrate/20110926214624_create_users.rb"
    copy_file "user.rb", "app/models/user.rb"
#    rake("db:migrate")
  end

  def generate_authentication_controllers
    copy_file "users_controller.rb", "app/controllers/users_controller.rb"
    copy_file "sessions_controller.rb", "app/controllers/sessions_controller.rb"
  end

  def generate_authentication_helpers
    # Insert users helper
    copy_file "users_helper.rb", "app/helpers/users_helper.rb"
    # Insert sessions helper
    copy_file "sessions_helper.rb", "app/helpers/sessions_helper.rb"
    # Add methods to spec_helper.rb
    spec_methods = <<eos
\n
  def test_sign_in(user)
    controller.sign_in(user)
  end

  def integration_sign_in(user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
eos
    insert_into_file "spec/spec_helper.rb", spec_methods, :before => "\nend"
    # Add sessions helper to application controller    
    insert_into_file "app/controllers/application_controller.rb", "\n  include SessionsHelper", :before => "\nend"
    # Add flash messages to application layout
    flash_messages = <<eos
\n
<% flash.each do |key, value| %>
  <%= content_tag(:div, value, :class => "flash \#{key}") %>
<% end %>
eos
    insert_into_file "app/views/layouts/application.html.erb", flash_messages, :before => "\n<%= yield %>"
    # Replace title in application layout
    gsub_file 'app/views/layouts/application.html.erb', /<title>\S*<\/title>/, "<title><%= @title %></title>"
  end

  def generate_user_views
    empty_directory "app/views/users"
    copy_file "views/users/index.html.erb", "app/views/users/index.html.erb"
    copy_file "views/users/new.html.erb", "app/views/users/new.html.erb" 
    copy_file "views/users/_fields.html.erb", "app/views/users/_fields.html.erb" 
    copy_file "views/users/show.html.erb", "app/views/users/show.html.erb" 
    copy_file "views/users/edit.html.erb", "app/views/users/edit.html.erb" 
  end

  def generate_sessions_views
    empty_directory "app/views/sessions"
    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
  end  

  def generate_shared_views
    empty_directory "app/views/shared"
    copy_file "views/_error_messages.html.erb", "app/views/shared/_error_messages.erb" 
  end

  def generate_authentication_routes
    remove_file "public/index.html"
    route "resources :users"
    route "resources :sessions, :only => [ :new, :create, :destroy ]"
    route "match '/signup', :to => 'users#new'"
    route "match '/signin', :to => 'sessions#new'"
    route "match '/signout', :to => 'sessions#destroy'"
    route "root :to => 'sessions#new'"
  end
end
