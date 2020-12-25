FROM ruby

WORKDIR /gdarruda.github.io

COPY . .

RUN bundle install

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--drafts", "--host=0.0.0.0"]
