class AuthenticationGenerator < Rails::Generators::Base
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

  def generate_user_tests
    copy_file "user_spec.rb", "spec/models/user_spec.rb"   
  end

  def generate_user_model
    
  end

end
