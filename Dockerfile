FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libxml2-dev \
  libxslt1-dev \
  nodejs
ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
EXPOSE 3000
