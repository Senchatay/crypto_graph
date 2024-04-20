FROM ruby:3.3.0-alpine

RUN apk update && apk add --no-cache build-base

WORKDIR /opt/app
COPY . .
RUN bundle install

EXPOSE 3000

CMD ["ruby", "app/main.rb"]