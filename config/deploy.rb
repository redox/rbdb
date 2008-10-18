set :user, "mbg"
set :application, "rbdb"
set :repository,  "git@github.com:railsrumble/mbg.git"

role :app, "li47-145.members.linode.com"
role :db, "li47-145.members.linode.com", :primary => true
role :web, "li47-145.members.linode.com"

set :deploy_to, "/var/www/apps/#{application}"
set :scm, :git
set :branch, "master"

namespace :deploy do
  desc "restart passenger"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :after_symlink do
    run "ln -nsf #{shared_path}/public/.htaccess #{current_path}/.htaccess"
    run "ln -nsf #{shared_path}/public/.htpasswd #{current_path}/.htpasswd"
    %w[database.yml].each do |c|
      run "ln -nsf #{shared_path}/system/config/#{c} #{current_path}/config/#{c}"
    end
  end
end