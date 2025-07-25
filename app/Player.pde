class Player extends Character {
  int score;
  
  // 無敵時間用の変数
  boolean invincible;
  int invincibleTimer;

  Player(String imgpath, float x, float y, int lives) {
    super(imgpath, x, y);
    this.lives = lives;
    this.score = 0;
    
    // 無敵時間用の変数を初期化
    this.invincible = false;
    this.invincibleTimer = 0;
  }

  void display() {
    // 無敵時間の処理
    if (this.invincible) {
      this.invincibleTimer--;
      if (this.invincibleTimer <= 0) {
        this.invincible = false;
      }
    }

    // プレイヤーの移動範囲制限
    if (this.position.x < 0) { this.position.x = 0; }
    else if (this.position.x > width - 100) { this.position.x = width - 100; }
    if (this.position.y < 0) { this.position.y = 0; }
    else if (this.position.y > height - 100) { this.position.y = height - 100; }
    
    // 無敵中の点滅表現
    if (!this.invincible || this.invincibleTimer % 2 == 0) {
       image(this.img, this.position.x, this.position.y, 100, 100);
    }
  }

  void move() {
    switch(keyCode) {
      case LEFT: this.position.x -= 5; break;
      case RIGHT: this.position.x += 5; break;
      case UP: this.position.y -= 5; break;
      case DOWN: this.position.y += 5; break;
    }
  }

  void colision(Character character) {
    if (this.invincible) return;
    
    if ((character.position.x - this.position.x) * (character.position.x - this.position.x) 
      + (character.position.y - this.position.y) * (character.position.y - this.position.y) < 1000) {
      this.lives--;
      this.invincible = true;
      this.invincibleTimer = 120;
      // デバッグ用: 衝突時のHPを表示
      println("衝突！敵と接触。残りHP: " + this.lives);
    }
  }
  
  void colisionObstacle(Obstacle obstacle) {
    if (this.invincible) return;

    if ((obstacle.x - (this.position.x + 50)) * (obstacle.x - (this.position.x + 50)) 
      + (obstacle.y - (this.position.y + 50)) * (obstacle.y - (this.position.y + 50)) < 1000) {
      this.lives--;
      this.invincible = true;
      this.invincibleTimer = 120;
      // デバッグ用: 衝突時のHPを表示
      println("衝突！障害物と接触。残りHP: " + this.lives);
    }
  }

  /** ボスの弾との当たり判定 */
  boolean colisionBossBullet(BossBullet b) {
    if (this.invincible) return false;

    float pCenterX = this.position.x + 50;
    float pCenterY = this.position.y + 50;
    float pRadius = 35;

    float bCenterX = b.position.x;
    float bCenterY = b.position.y;
    float bRadius = b.size / 2;

    float distanceSq = pow(pCenterX - bCenterX, 2) + pow(pCenterY - bCenterY, 2);
    float radiiSq = pow(pRadius + bRadius, 2);

    if (distanceSq < radiiSq) {
      this.lives--;
      this.invincible = true;
      this.invincibleTimer = 120;
      // デバッグ用: 衝突時のHPを表示
      println("衝突！ボスの弾に接触。残りHP: " + this.lives);
      return true;
    }
    return false;
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