class Enemy extends Character {
  float speed;
  int x,y;
  Enemy(String imagePath, float speed,int x,int y) {
    
    super(imagePath, random(width), 0);
    
    // 親から継承したlives（残機）を1に設定
    this.lives = 1; 
    
    // この敵の移動速度を保存
    this.speed = speed;
    this.x=x;
    this.y=y;
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
  
  void display(int x,int y){
     image(this.img, this.position.x, this.position.y,x,y);
     this.update();
  }
}



  