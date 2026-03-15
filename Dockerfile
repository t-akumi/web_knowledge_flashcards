FROM ruby:3.3.4

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 依存を先に入れてキャッシュ効かせる
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . .

CMD ["bash", "-lc", "./bin/rails server -b 0.0.0.0 -p 3000"]
