#!/usr/bin/env bash
set -o errexit

bundle install

# アセットを使っているなら（通常は必要）
bundle exec rails assets:precompile
bundle exec rails assets:clean

# DBマイグレーション（本番は必須）
bundle exec rails db:migrate

# AI使用なし用のシード
bundle exec rails db:seed