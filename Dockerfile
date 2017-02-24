FROM ruby:2.2.4

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev

ENV BUNDLE_JOBS 4
ENV RAILS_ENV development
ENV RAILS_PORT 3000

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir /hacken-in
WORKDIR /hacken-in
ADD . /hacken-in

CMD ./bin/rails server -p $RAILS_PORT -b 0.0.0.0
