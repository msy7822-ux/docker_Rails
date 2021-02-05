FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
########################################################################
# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn
# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install nodejs
#######################################################################
RUN mkdir /food_app
WORKDIR /food_app
COPY Gemfile /food_app/Gemfile
COPY Gemfile.lock /food_app/Gemfile.lock
RUN bundle install
COPY . /food_app

# コンテナが起動するたびに実行されるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# イメージ内部のソフトウェア実行（ここではRailsを指す）
CMD ["rails", "server", "-b", "0.0.0.0"]