

# cp-win-spot

[![GitHub license](<https://img.shields.io/github/license/suyeden/cp-win-spot?color=blue>)](<https://github.com/suyeden/cp-win-spot/blob/master/LICENSE>)  

`cp-win-spot.el` は Windows Spotlight の画像を任意のディレクトリに保存するためのスクリプトです。  
Windows 10 のログイン画面に出てくる綺麗な画像を手軽に保存することができます。  
本スクリプトは Emacs Lisp で書かれており、スクリプトの実行には Emacs のインストールが必要となります。  


## 動作環境

-   Windows 10 Home
-   GNU Emacs 27.1 以上


## 使用方法

1.  GNU Emacs 27.1 以上をインストールし、Emacs の実行ファイルが置かれたディレクトリまでのパスを通してください。
2.  `cp-win-spot` を git clone するか、もしくはこの GitHub から Zip ファイルをダウンロードして適当な場所に解凍してください。
3.  展開した `cp-win-spot` ディレクトリ内にある `.config_cpws.txt` ファイル（無ければ自分で作成してください）の1行目に、写真のコピー先にしたいディレクトリのフルパスを記述してください。
4.  コマンドプロンプトにて、cd コマンドで `cp-win-spot` ディレクトリ内に移動してください。
5.  コマンドプロンプトにて、 `emacs --script cp-win-spot.el` を実行してください。  
    手順 3 で `.config_cpws.txt` ファイル内に記述したディレクトリの中に、Windows Spotlight の画像がコピーされているはずです。  
    Windows Spotlight の画像は定期的に自動で更新されるので、本スクリプトを定期的に実行してあげてください。まだコピーされていない画像のみが新たにコピーされます。


## メモ

`.config_cpws.txt` を配置する場所は、本スクリプトを実行する時に自分がいる場所に置けば良いため、 `cp-win-spot` ディレクトリ内に必ず置く必要はありません。  
バッチファイル化した場合はバッチファイルと同じ場所に置いたら良いですし、コマンドプロンプトからコマンドを実行する際はカレントディレクトリに配置すれば大丈夫です。  

