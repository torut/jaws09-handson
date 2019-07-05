# ハンズオンの内容

S3バケットのファイルリストを取得して署名済みURLを取得して表示を確認する.
→Lambda で Ruby を使ってバケットの内のリストを取得してURLをリスト化する。
→→API GatewayをつかってLambdaを呼び出してブラウザに表示する。

# つかうサービス

- IAM
- S3
- Lambda
- API Gateway

# IAM でLambdaに設定するアクセスキーを作成

AWSマネージメントコンソールで画面右上のリージョンが **東京** であることを確認。

1. AWSマネージメントコンソールの **AWSのサービス** のところで「iam」と入力して表示されるリストの1番目を選択する
2. 画面左側のメニューから **ユーザー** を選択する
3. 「ユーザーを追加」ボタンをクリックする
4. ユーザー名には **20190706-jaws09-lambda** と入力し、アクセスの種類は **プログラムによるアクセス** を選択して「次のステップ」ボタンをクリックする。
5. アクセス権限の許可は「既存のポリシーを直接アタッチ」を選択し、 **ポリシーのフィルタ** に `S3` と入力すると *AmazonS3FullAccess* があるのでそれのチェックボックスをチェックして「次のステップ」をクリックする
6. タグはとくに設定は不要で「次のステップ」をクリックする
7. 確認画面では **AWSアクセスの種類** が「プログラムによるアクセス-アクセスキーを使用」となっていて、 **アクセス権限** に 「AmazonS3FullAccess」があることを確認し「ユーザーの作成」をクリックする
8. ユーザーが追加されるので、「.csvのダウンロード」ボタンでCSVをダウンロードしておく


# Lambda&API Gateway の作成はAWSコンソールから

# Lambda

AWSマネージメントコンソールで画面右上のリージョンが **東京** であることを確認。

## Lambda関数の作成

1. AWSマネージメントコンソールの **AWSのサービス** のところで「lambda」と入力して表示されるリストの1番目を選択する
2. 画面左上の「≡」のアイコンをクリックしてサイドメニューを開き、「ダッシュボード」をクリックする
3. オレンジの「関数の作成」をクリックする
4. 「一から作成」を選択して、「関数名」を適時入力、「ランタイム」は **Ruby 2.5** を選択、「アクセス権限」は **実行ロールの選択または作成** をクリックし展開された「実行ロール」が **基本的なLambdaアクセス権限で新しいロールを作成** になっていることを確認し、右下の「関数の作成」ボタンをクリックする

# Lambda関数の設定

Rubyに対応しているのでrubyで実装してみる。
aws-sdk を使ってS3へアクセスして結果をJSONで出力するものにする
それぞれのオブジェクトのリンクは署名済みURLにする。

関数エディタに下記のソースコードをコピペする。

see: [lambda.rb](/lambda.rb)

### 環境変数の設定

キー | 値
---|---
REGION| `ap-northeast-1`
ACCESS_KEY| (IAMで作成したユーザーのアクセスキー)
SECRET_ACCESS_KEY| (IAMで作成したユーザーのシークレットキー)
BUCKET_NAME|`jaws09-20190706-<姓>` <br>例: jaws09-20190706-tamura)

IAMで作成したユーザーのアクセスキー、シークレットキーはダウンロードしておいたCSVからコピペする。

### 基本設定

基本設定のところで **タイムアウト** が *3秒* になっているので *30秒* に変更する。


その他はデフォルトのまま、画面右上の「保存」をしてから「テスト」ボタンをクリックして、実行結果が **成功** になればOK



# API Gateway

ブラウザからLambdaにアクセスできるように設定する。

AWSマネージメントコンソールで画面右上のリージョンが **東京** であることを確認。

## API Gatewayの作成

1. AWSマネージメントコンソールの **AWSのサービス** のところで「api」と入力して表示されるリストの1番目を選択する
2. 「今すぐ始める」ボタンをクリックする
3. 新しいAPIの作成になるので、 **REST** が選択されていることを確認したら **新しいAPI** を選択し、名前と説明を入力し、右下の「APIの作成」をクリックする。
    * 名前: `jaws09-20190706-<姓>`
    * エンドポイントタイプ: リージョン
4. メソッド定義画面になるので、左上の **アクション** から「メソッドの作成」を選択するとう表示されるプルダウンから **GET** を選択する
5. GETメソッドに対するアクションの設定を行う
    * 統合タイプ: **Lambda関数**
    * Lambdaリージョン: **ap-northeast-1**
    * Lambda関数: 先ほど作成したLambda関数の名前を入れる(数文字入力するとオートコンプリート表示されるので選択)
6. 「保存」すると  **Lambda 関数に権限を追加する**  と聞いてくるので「OK」をクリックする。
7. メソッドの実行画面になるので、右下の「統合レスポンス」をクリックする。
8. **メソッドレスポンスのステータス** が *200* の行があるのでその行の左端の▲をクリックして行を展開すると **マッピングテンプレート** があるので、再び▲で展開する。
9. **application/json** があるのでそれをクリックすると右側に入力欄が表示されるので `{ }` となっているところを `$input.json("$.body")` に変更して「保存」する。
10. 保存したら画面上の「←メソッドの実行」リンクをクリックして、メソッドの実行画面にもどり、「テスト」のリンクをクリックするとメソッドテストになるので「テスト」ボタンをクリックする。
11. 右半分にテスト結果のレスポンスが表示されればOK
12. **アクション** から「CORSの有効化」を選択して、**GET** にチェックが付いていることを確認して右下のボタンをクリックする
13. **アクション** から「APIのデプロイ」を選択して、それそれ入力し「デプロイ」する
    * デプロイされるステージ: **新しいステージ**
    * ステージ名: **prod**
14. デプロイ後のURLが表示されているのでそのURLを新しいウィンドウで開いてレスポンスが表示されていればOK.

# ブラウザからAPI Gatewayを呼び出してjqueryでjsonをhtmlにレンダリングする

see: [index.html](/index.html)