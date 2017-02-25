FROM ruby:2.2.4

ENV BUNDLE_JOBS 4
ENV RAILS_ENV production
ENV RAILS_PORT 3000
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile* /app/
RUN apt-get update -qq && \
  mkdir -p /app/tmp /gems && \
  apt-get install -y build-essential libpq-dev && \
  groupadd --gid 4711 hacken && \
  useradd -m --uid 4711 --gid 4711 hacken && \
  chown hacken:hacken -Rv /app /gems

USER hacken

WORKDIR /app
RUN bundle install --path=/gems
COPY . /app

CMD ["rails server -p $RAILS_PORT -b 0.0.0.0 -P /tmp/server.pid"]
ENTRYPOINT ["bundle", "exec"]
