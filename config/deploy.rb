# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'so'
set :repo_url, 'git@github.com:shilin/so.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/so'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
# in 'shared' folder
append :linked_files, 'config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml'

# Default value for linked_dirs is []
# in 'shared' folder too
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -d -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, 'exec thin -d -C config/private_pub_thin.yml start'
          execute :bundle, 'exec thin -d -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
# after 'deploy:restart', 'thinking_sphinx:restart'
