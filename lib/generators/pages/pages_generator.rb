class PagesGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def setup_rspec
    gem "rspec", :group => "test"
    gem "webrat", :group => "test"
    gem "rspec-rails", :group => "development"
    
    empty_directory "spec/"
    empty_directory "spec/controllers"
    empty_directory "spec/models"
    empty_directory "spec/requests"
    
    copy_file "spec_helper.rb", "spec/spec_helper.rb"
  end

  def generate_pages_tests
    copy_file "pages_controller_spec.rb", "spec/controllers/pages_controller_spec.rb"
    copy_file "layout_links_spec.rb", "spec/requests/layout_links_spec.rb"
  end

  def generate_pages_controller
    copy_file "pages_controller.rb", "app/controllers/pages_controller.rb"
  end

  def generate_pages_views
    empty_directory "app/views/pages"
    template "home.html.erb", "app/views/pages/home.html.erb"
    template "about.html.erb", "app/views/pages/about.html.erb"
    # Replace title in application layout
    gsub_file 'app/views/layouts/application.html.erb', /<title>\S*<\/title>/, "<title><%= @title %></title>"
  end

  def generate_pages_routes
    route "root :to => 'pages#home'"
    route "match '/about', :to => 'pages#about'"
  end

  def generate_pages_helpers
    title_method = <<eos
\n
  # Return a title on a per-page basis
  def title
    base_title = "My New App"
    if @title.nil?
      base_title
    else
      "\#{base_title} | \#{@title}"
    end
  end 
eos
    insert_into_file "app/helpers/application_helper.rb", title_method, :before => "\nend"
    copy_file "pages_helper.rb", "app/helpers/pages_helper.rb"
  end

  def remove_default_index
    remove_file "public/index.html"
  end
end
