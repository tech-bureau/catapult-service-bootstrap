FROM alpine:3.7
RUN apk add --no-cache ruby ruby-bundler
RUN gem install mustache --no-ri --no-rdoc
RUN apk add --no-cache ruby-dev build-base ruby-irb emacs-nox
RUN gem install byebug --no-ri --no-rdoc