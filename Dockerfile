FROM ruby:2.5.5-alpine
WORKDIR /issue-creator

ENV GH_TOKEN=
ENV RAILS_ENV=development

RUN apk update && apk add --no-cache \
  bash \
  freetds \
  nodejs \
  alpine-sdk \
  freetds-dev \
  libxml2-dev \
  libxslt-dev

COPY . .

RUN bundle install --jobs=4
EXPOSE 3000
ENTRYPOINT ["bundle","exec", "puma", "-C", "config/puma.rb"]