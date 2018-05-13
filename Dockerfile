FROM ruby:2.4.4

ENV BUNDLE_JOBS=4 \
  RAILS_ENV=production \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_LOG_TO_STDOUT=true \
  BUNDLE_PATH="/bundle" \
  PATH="/app/bin:${PATH}"

RUN useradd -m hacken && \
  mkdir /app && \
  mkdir /bundle && \
  chown hacken:hacken -Rv /app /bundle

WORKDIR /app
USER hacken
EXPOSE 3000

COPY --chown=hacken:hacken Gemfile* /app/

RUN bundle install

COPY --chown=hacken:hacken . /app

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:3000/deutschland || exit 1

CMD bundle exec puma -C config/puma.rb
