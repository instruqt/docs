FROM ruby:2.3.3
RUN git clone --depth=1 https://github.com/lord/slate.git
WORKDIR slate
RUN gem install bundle
RUN bundle install
RUN apt-get update && apt-get install -y nodejs && apt-get clean && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["bundle", "exec", "middleman"]
CMD ["build", "--clean", "--verbose"]
