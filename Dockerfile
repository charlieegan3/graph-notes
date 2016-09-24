FROM ruby

WORKDIR /app

COPY ./bundle /usr/local/bundle/
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install && bundle clean
RUN printf '#!/bin/sh\ncp -r /usr/local/bundle /app\n' > /usr/local/bin/cache-bundle
RUN chmod +x /usr/local/bin/cache-bundle

COPY . /app

EXPOSE 3000

CMD rails s -b 0.0.0.0 -p 3000
