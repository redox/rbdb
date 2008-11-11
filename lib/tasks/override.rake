# Monkey patch to avoid pending migrations check on rake tests
namespace :db do 
  override_task :abort_if_pending_migrations do 
    # skipping migration
  end
end 