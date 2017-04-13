FROM ruby:2.3.3

WORKDIR /app

ADD ./bundle.tar.gz /
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install && bundle clean
RUN printf '#!/bin/sh\ntar -zcf /app/bundle.tar.gz /usr/local/bundle\n' > /usr/local/bin/bundlecache
RUN chmod +x /usr/local/bin/bundlecache

COPY . /app

EXPOSE 3000

CMD rails s -b 0.0.0.0 -p 3000
