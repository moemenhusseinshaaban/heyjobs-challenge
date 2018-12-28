FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /application
WORKDIR /application
COPY heyjobs/Gemfile /application/Gemfile
COPY heyjobs/Rakefile /application/Rakefile
RUN bundle install
COPY . /application
CMD while true ; do sleep 1 ; done
