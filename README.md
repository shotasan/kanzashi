# README

## 概要
***
珈琲豆の味やその他の情報を管理する。<br>
好きな珈琲豆を組み合わせて自分だけのオリジナルブレンドを作るのに役立ちます。<br>
他のユーザーが記録した珈琲豆の情報を見れるので、今まで飲んだことのない珈琲にチャレンジできます。

## コンセプト
***
珈琲豆の情報管理と情報交換アプリ

## バージョン
***
Ruby 2.6.3<br>
Rails 5.2.3<br>
PostgreSQL 11.3

## 機能
***
### 珈琲豆の記録と味の評価
- 珈琲豆の詳細な情報や、味の評価を記録することが出来ます。
- 総合評価、苦味、酸味、コク、甘み、香りについて五段階で評価することが出来ます。

<img alt="スクリーンショット" src="https://user-images.githubusercontent.com/45532225/67449722-0ef3f480-f656-11e9-9268-1386e801280a.png">

### オリジナルブレンドの作成
- 好きな珈琲豆を組み合わせてオリジナルブレンドを作成することができます。
- 豆は３種類まで選択可能です。
- それぞれの豆について挽き方や焙煎方法、投入量を選択できるので様々な組み合わせを試すことが出来ます。
<div>
<img alt="スクリーンショット" src="https://user-images.githubusercontent.com/45532225/67448531-38128600-f652-11e9-8c7e-b59f268aa7fe.png">
<img alt="スクリーンショット" src="https://user-images.githubusercontent.com/45532225/67448195-40b68c80-f651-11e9-9041-8f59db7d538d.png">
</div>

### 珈琲豆の検索
- ユーザーが投稿したレビューを検索することが出来ます。
- 総合評価や味の評価で検索することが出来るため、自分の好みに近い豆を探したり、逆に普段飲まない豆を探すことが出来ます。
<div>
<img alt="スクリーンショット" width="50%" src="https://user-images.githubusercontent.com/45532225/67452418-1fa86880-f65e-11e9-9a93-dc7ebcf36227.png"><img width="50%" src="https://user-images.githubusercontent.com/45532225/67452550-8ded2b00-f65e-11e9-97ab-eb1cec8feb51.png">
</div>

## ER図
***
<img alt="スクリーンショット" src="https://cacoo.com/diagrams/V1AtthFAbqJ7hbPK-F4302.png">