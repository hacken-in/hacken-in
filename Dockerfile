FROM ruby:2.2.4

ENV BUNDLE_JOBS 4
ENV RAILS_ENV production
ENV RAILS_PORT 3000

COPY Gemfile* /app/
RUN apt-get update -qq && \
  mkdir -p /app/vendor /app/tmp && \
  apt-get install -y build-essential libpq-dev && \
  groupadd --gid 4711 hacken && \
  useradd -m --uid 4711 --gid 4711 hacken && \
  chown hacken:hacken -Rv /app

USER hacken

WORKDIR /app
RUN bundle install --path=vendor/gems
COPY . /app

CMD ./bin/rails server -p $RAILS_PORT -b 0.0.0.0
