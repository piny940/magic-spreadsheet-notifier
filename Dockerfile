FROM ruby:3.4.1 as builder

RUN gem install bundler
COPY Gemfile Gemfile.lock ./
ENV ENV=production
RUN ENV=${ENV} bundle install

FROM ruby:3.4.1 as app

RUN apt-get update && \
  apt-get install -y \
  tzdata \
  postgresql-client \
  libnss3 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libxkbcommon-x11-0 \
  libxdamage1 \
  libxcomposite-dev \
  libxrandr2 \
  libgbm1 \
  libasound2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -P /tmp https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chrome-linux64.zip \
  && unzip /tmp/chrome-linux64.zip -d /usr/lib \
  && ln -s /usr/lib/chrome-linux64/chrome /usr/local/bin/chrome \
  && wget -P /tmp https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chromedriver-linux64.zip \
  && unzip /tmp/chromedriver-linux64.zip -d /usr/lib \
  && ln -s /usr/lib/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .

CMD ["bundle", "exec", "rake"]
