FROM ruby:3.2-alpine

COPY Gemfile Gemfile.lock ./
RUN bundle install

WORKDIR /serverspec

ENTRYPOINT ["rspec"]
CMD ["-h"]