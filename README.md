# 魔法のスプレッドシート更新通知

<p>
  <img alt="Release" src="https://github.com/piny940/magic-spreadsheet-notifier/actions/workflows/release.yml/badge.svg" />
</p>
<p>
  <a href="https://gyazo.com/14c07137abf9db6df8e40b77e1ba4ddb"><img src="https://i.gyazo.com/14c07137abf9db6df8e40b77e1ba4ddb.png" alt="Image from Gyazo" width="1643"/></a>
</p>

1 日 1 回[魔法のスプレッドシート](https://magic-spreadsheets.pages.dev)を読みに行き、更新があった場合は Slack に通知を送ります。

Slack Bot をワークスペースに追加するには[こちら](https://magic-spreadsheet-notifier.piny940.com)から「SlackApp を追加」してください。

## 使用技術

- Ruby 3.1.2
- [Selenium](https://www.selenium.dev/selenium/docs/api/rb/)
- Golang 1.21.1
- Echo 4.11.3
- Firestore

## 本番環境

`docker build` + `docker run`で起動します。

## 開発環境

**SlackApp**

- `.env.sample`に従い環境変数を設定
- `docker compose up --build`

**Server**  
SlackApp の認証のためのサーバーです。Echo(Golang)で書かれています。

- `.env.sample`に従い環境変数を設定
- `cd server`
- `go run .`
