// Boss.java

import java.util.ArrayList;

class Boss extends Character {
  float speed;             // ボス縦移動速度
  int   maxLives;          // ボス耐久力
  int   attackTimer;       // 攻撃カウンタ
  ArrayList<BossBullet> bullets;  // このボスが生成した弾リスト

  Boss(String imagePath, float startX, float startY, float speed, int maxLives) {
    super(imagePath, startX, startY);
    this.speed       = speed;
    this.maxLives    = maxLives;
    this.lives       = maxLives;
    this.attackTimer = 0;
    this.bullets     = new ArrayList<BossBullet>();
  }

  void update() {
    // 縦に降下 → 上部到達後は左右往復
    if (position.y < height * 0.2) {
      position.y += speed;
    } else {
      position.x += speed * 0.5;
      if (position.x < 50 || position.x > width - 50) {
        speed *= -1;
      }
    }

    // 攻撃タイマー
    attackTimer++;
    if (attackTimer >= 120) {      // 2秒ごと
      attack();
      attackTimer = 0;
    }

    // すべてのボス弾を移動・画面外なら削除
    for (int i = bullets.size() - 1; i >= 0; i--) {
      BossBullet b = bullets.get(i);
      b.move();
      if (b.isOffScreen()) {
        bullets.remove(i);
      }
    }
  }

  /** 3方向にボス弾を生成 */
  void attack() {
    float x = position.x;
    float y = position.y + 60;
    bullets.add(new BossBullet(x, y,  0,  5));
    bullets.add(new BossBullet(x, y, -2,  5));
    bullets.add(new BossBullet(x, y,  2,  5));
  }

  void display() {
    // 大きく描画
    image(img, position.x - 75, position.y - 75, 150, 150);
    update();

    // ボス弾も描画
    for (BossBullet b : bullets) {
      b.display();
    }
  }

  boolean isDefeated() {
    return lives <= 0;
  }
}


// BossBullet.java

class BossBullet {
  PVector position;
  PVector velocity;
  float   size = 16;

  BossBullet(float x, float y, float vx, float vy) {
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
  }

  void move() {
    position.add(velocity);
  }

  void display() {
    fill(255, 100, 0);
    noStroke();
    ellipse(position.x, position.y, size, size);
  }

  boolean isOffScreen() {
    return (position.y > height || position.x < 0 || position.x > width);
  }
}