FROM alpine:3.11
RUN apk add --no-cache ruby ruby-bundler
RUN apk add --no-cache openssl
RUN gem install mustache 

# for debugging
RUN apk add ruby-dev ruby-irb g++ make
RUN gem install byebug