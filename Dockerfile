FROM ruby

WORKDIR /gdarruda.github.io

COPY . .

RUN bundle install

EXPOSE 4000

<<<<<<< HEAD
CMD bundle exec jekyll serve --drafts --host=0.0.0.0
=======
CMD ["bundle", "exec", "jekyll", "serve", "--drafts", "--host=0.0.0.0"]
>>>>>>> 51137743dc499be71f043427565eab8a166a9a88
