class Enemy extends Character {
  
  float speed; // 敵の移動速度

  // Enemyクラスのコンストラクタ
  // 自身（Enemy）を生成する際に、画像パスと速度を引数として受け取る
  Enemy(String imagePath, float speed) {
    // super(...)を使って、親であるCharacterクラスのコンストラクタを呼び出す
    // 画像パスを渡し、初期位置はy=0, xは画面幅内でランダムに設定
    super(imagePath, random(width), 0);
    
    // 親から継承したlives（残機）を1に設定
    this.lives = 1; 
    
    // この敵の移動速度を保存
    this.speed = speed;
  }

  // 毎フレームごとの更新処理
  void update() {
    // y軸（縦方向）にspeedの分だけ移動させる
    this.position.y += this.speed;
  }
  
  // 敵が画面の下端に到達したかを判定するメソッド
  boolean isOffScreen() {
    // 敵のy座標が画面の高さを超えたらtrueを返す
    if (this.position.y > height) {
      return true;
    } else {
      return false;
    }
  }
}

class Enemy1 extends Enemy {
  Enemy1() {
    // "enemy1.png" という画像と、移動速度 2.0 を指定
    super("enemy1.png", 2.0); 
  }
}

class Enemy2 extends Enemy {
  Enemy2() {
    // "enemy2.png" という画像と、移動速度 3.5 を指定
    super("enemy2.png", 3.5);
  }
}

class Enemy3 extends Enemy {
  Enemy3() {
    // "enemy3.png" という画像と、移動速度 1.5 を指定
    super("enemy3.png", 4.5);
  }
}