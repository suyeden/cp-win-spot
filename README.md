

# cp-win-spot

[![GitHub license](<https://img.shields.io/github/license/suyeden/cp-win-spot?color=blue>)](<https://github.com/suyeden/cp-win-spot/blob/master/LICENSE>)  

`cp-win-spot.el` は Windows Spotlight の画像を任意のディレクトリに保存するためのスクリプトです。  
Windows 10 のログイン画面に出てくる画像を保存します。  
このスクリプトは Emacs Lisp で書かれており、スクリプトの実行には Emacs のインストールが必要です。  


## 動作環境

-   Windows 10 Home
-   GNU Emacs 27.1


## 使用方法

-   Emacs をインストールし、emacs.exe までのパスを通す。
-   `cp-win-spot` を git clone するか、もしくはこの GitHub から Zip ファイルをダウンロードして適当な場所に解凍。
-   展開した `cp-win-spot` ディレクトリ内にある `.config_cpws.txt` ファイル（無ければ自分で作成してください）の1行目に、写真のコピー先にしたいディレクトリのフルパスを記述。
-   コマンドプロンプトにて、展開した `cp-win-spot` ディレクトリ内に移動。
-   コマンドプロンプトにて、 `emacs --script cp-win-spot.el -kill` を実行。  
    手順 3 で `.config_cpws.txt` ファイル内に記述したディレクトリの中に、Windows Spotlight の画像がコピーされる。（まだコピーされていない画像のみコピー）

