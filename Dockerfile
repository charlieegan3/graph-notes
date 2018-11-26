FROM ruby:2.3.3

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install && bundle clean

COPY . /app

RUN DATABASE_URL=none bundle exec rails assets:precompile

CMD rails s -b 0.0.0.0 -p 3000
