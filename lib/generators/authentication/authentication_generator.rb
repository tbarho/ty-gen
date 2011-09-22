class AuthenticationGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_user_migration
    copy_file "create_users.rb", "db/migrate/create_users.rb"    
  end
end
