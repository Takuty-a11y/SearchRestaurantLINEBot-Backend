<div align="center">
    <img src="https://user-images.githubusercontent.com/89084713/198834963-c79609f4-728a-4f62-b2b5-763f4abd5570.png" alt="Icon">
</div>

# Search Restaurant LINE Bot

LINE メッセージまたは位置情報からホットペッパーで検索した飲食店の上位 10
件を表示します。<br>
詳細検索画面からジャンル/エリア/価格帯で検索することもできます。

[こちらから友達追加できます](https://lin.ee/pISheJz)

## Get Started

1. Clone repository

```bash
$ git clone https://github.com/Takuty-a11y/SearchRestaurantLINEBot-Backend.git
```

2. Move directory

```bash
$ cd SearchRestaurantLINEBot-Backend
```

3. Dockerimage build

```bash
$ docker-compose build
```

4. Container up

```bash
$ docker-compose up -d
```

## Usage

[こちらに記事にしています](https://zenn.dev/takuty)

## Requirement

- Ruby@3.1.2
- Ruby on Rails@7.0.4
- Postsql@1.1
- puma@5.0
- rack-cors
- line-bot-api
- httpclient
