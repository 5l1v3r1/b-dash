# Setup

% bundle install

% bundle exec rake db:migrate

% foreman start

# Deploy to heroku

% heroku config:add BASIC_AUTH_USERNAME="foo" BASIC_AUTH_PASSWORD="bar" --app APPNAME

% heroku addons:add heroku-postgresql
