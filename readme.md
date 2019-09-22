# JAWS-UG Shimane vol.9 =ハンズオン= 資料

2019/07/06 に開催した [JAWS-UG Shimane vol.9 =ハンズオン=](https://jawsug-shimane.doorkeeper.jp/events/92968) で行ったハンズオンの資料です.

※:スクリーンショットなどは 2019年7月現在のものです.

## 前半: [1st-half.md](/1st-half.md)

### AWS SDK JSを使ってブラウザから簡単にS3へファイルアップロードする.
### アクセスキー、シークレットキーは使わず Congnito のIDプールを使ってみる.

- S3
- Cognito
- IAM


## 後半: [2nd-half.md](/2nd-half.md)

### S3にアップロードしたファイルをサーバレスでブラウザから確認できるようにする.
### アクセスキー、シークレットキーは使わず Lambda に設定する role に権限を付与する.

- IAM
- S3
- Lambda (by Ruby)
- API Gateway


## あとかたづけ: [loss-time.md](/loss-time.md)

### ハンズオンで作成したリソースの削除.
