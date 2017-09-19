FROM ruby:2.4.2

COPY pkg/flight-excel-roo.gem /tmp

RUN gem install /tmp/flight-excel-roo.gem
