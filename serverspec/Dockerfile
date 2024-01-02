FROM ruby:3.3-alpine

RUN apk add --update --no-cache \
    docker-cli

COPY Gemfile Gemfile.lock ./
RUN bundle install

WORKDIR /serverspec

ENTRYPOINT ["rspec"]
CMD ["-h"]