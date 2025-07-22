// Player.pde ファイルの中身を、このコードに丸ごと置き換えてください

class Player extends Character {
  int score;
  
  // 無敵時間用の変数を追加 
  boolean invincible;      // 無敵状態かどうか
  int invincibleTimer;   // 無敵時間のタイマー

  Player(String imgpath, float x, float y, int lives) {
    super(imgpath, x, y);
    this.lives = lives;
    this.score = 0;
    
    //  無敵時間用の変数を初期化 
    this.invincible = false;
    this.invincibleTimer = 0;
  }

  void display() {
    //  無敵時間の処理を追加 
    if (this.invincible) {
      this.invincibleTimer--; // タイマーを減らす
      if (this.invincibleTimer <= 0) {
        this.invincible = false; // タイマーが0になったら無敵解除
      }
    }

    // プレイヤーの移動範囲制限
    if (this.position.x < 0) {
      this.position.x = 0;
    } else if (this.position.x > width - 100) {
      this.position.x = width - 100;
    }
    if (this.position.y < 0) {
      this.position.y = 0;
    } else if (this.position.y > height - 100) {
      this.position.y = height - 100;
    }
    
    //  無敵中の点滅表現を追加 
    // invincibleがtrue、かつ、タイマーが偶数のフレームの時だけ描画する
    if (!this.invincible || this.invincibleTimer % 2 == 0) {
       image(this.img, this.position.x, this.position.y, 100, 100);
    }
  }

  void move() {
    switch(keyCode) {
    case LEFT:
      this.position.x -= 5;
      break;
    case RIGHT:
      this.position.x += 5;
      break;
    case UP:
      this.position.y -= 5;
      break;
    case DOWN:
      this.position.y += 5;
      break;
    }
  }

  //  衝突判定を修正 
  void colision(Character character) {
    // 無敵中はダメージを受けない
    if (this.invincible) {
      return;
    }
    
    // (ここは元の当たり判定ロジック)
    if ((character.position.x - this.position.x) * (character.position.x - this.position.x) 
      + (character.position.y - this.position.y) * (character.position.y - this.position.y) < 1000) {
      this.lives--;
      this.invincible = true;      // 無敵状態にする
      this.invincibleTimer = 60;  // 無敵時間をセット（120フレーム = 約2秒）
      println("衝突！敵と接触。残りHP: " + this.lives); // デバッグ用
    }
  }
  
  //  障害物との衝突判定も修正 
  void colisionObstacle(Obstacle obstacle) {
    // 無敵中はダメージを受けない
    if (this.invincible) {
      return;
    }
    if ((obstacle.x - (this.position.x + 50)) * (obstacle.x - (this.position.x + 50)) 
      + (obstacle.y - (this.position.y + 50)) * (obstacle.y - (this.position.y + 50)) < 1000) {
      this.lives--;
      this.invincible = true;      // 無敵状態にする
      this.invincibleTimer = 60;  // 無敵時間をセット（120フレーム = 約2秒）
       println("衝突！障害物と接触。残りHP: " + this.lives); // デバッグ用
    }
  }

  boolean scoreFunc(Bullet bullet, Character character) {
    if (((character.position.x + 50) - bullet.x) * ((character.position.x - 50) - bullet.x) 
      + ((character.position.y + 50) - bullet.y) * ((character.position.y + 50) - bullet.y) < 1000) {
      character.lives--;
      this.score += 10;
      return true;
    }
    return false;
  }
}