FROM ruby:2.2.4

ENV BUNDLE_JOBS 4
ENV RAILS_ENV production
ENV PUMA_PORT 3000
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV BUNDLE_BIN false
ENV PATH "/app/bin:${PATH}"

COPY Gemfile* /app/
RUN apt-get update -qq && \
  mkdir -p /app/tmp /gems && \
  apt-get install -y build-essential libpq-dev && \
  gem install bundler && \ # upgrade to latest Bundler
  groupadd --gid 4711 hacken && \
  useradd -m --uid 4711 --gid 4711 hacken && \
  chown hacken:hacken -Rv /app /gems

USER hacken

WORKDIR /app
RUN bundle install --path=/gems
COPY . /app

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:3000/deutschland || exit 1

CMD bundle exec puma -C config/puma.rb
