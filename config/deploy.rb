$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano_colors'

set :domain, "foxhunt.httplab.ru"
set :application, "foxhunt_webapp"
set :deploy_to, "/var/www/#{domain}"

set :user, "dev"
set :use_sudo, false

set :scm, :git
set :repository, "git@github.com:httplab/foxhunt-webapp.git"
set :branch, 'master'
set :git_shallow_clone, 1

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_via, :copy
set :copy_exclude, [".git"]

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.9.2'

set :rails_env, :production
set :rack_env, :production

set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
require 'capistrano/ext/rvm-unicorn'

after 'deploy:symlink', 'deploy:app_symlinks'

namespace :deploy do
  task :app_symlinks do
    run <<-CMD
      rm -f #{current_release}/config/database.yml &&
      ln -s #{shared_path}/config/database.yml #{current_path}/config/database.yml
    CMD
  end
end