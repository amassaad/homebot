FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /homebot
WORKDIR /homebot
ADD Gemfile /homebot/Gemfile
ADD Gemfile.lock /homebot/Gemfile.lock

RUN bundle install
ADD . /phone-gateway

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

EXPOSE 29819
# Begin

CMD 'scripts/startup.sh'
