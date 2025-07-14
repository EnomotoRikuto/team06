class Character {

  PImage img;      // キャラクターの画像
  PVector position; // キャラクターの位置 (x, y座標)
  
  // 残機（ライフ）。子クラスで具体的な値を設定
  int lives;

  Character(String imagePath, float x, float y) {
    
    // 画像ファイルを読み込み、img変数に格納する
    this.img = loadImage(imagePath);
    
    // 位置ベクトルを、引数で受け取ったx, yで初期化する
    this.position = new PVector(x, y);
    
    // 残機を0で初期化
    this.lives = 0;
  }

  // 画面にキャラクターを描画するメソッド
  void display() {
    // 画像の中心がpositionの位置になるように描画する
    image(this.img, this.position.x, this.position.y);
  }
}
