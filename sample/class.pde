class Player {
  float x, y;
  float speed = 5;

  Player() {
    x = width / 2;
    y = height - 60;
  }

  void update() {
    x = constrain(x, 20, width - 20);
    y = constrain(y, 20, height - 20);
  }

  void display() {
    fill(0, 255, 0);
    triangle(x, y, x - 10, y + 20, x + 10, y + 20);
  }

  void moveX(int dir) {
    x += dir * speed;
  }

  void moveY(int dir) {
    y += dir * speed;
  }
}
class Bullet {
  float x, y;
  float speed = 7;

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    y -= speed;
  }

  void display() {
    fill(255);
    ellipse(x, y, 5, 10);
  }

  boolean offscreen() {
    return y < 0;
  }
}
class Enemy {
  float x, y;
  float speed;
  float size;
  String type;
  color col;

  Enemy() {
    x = random(20, width - 20);
    y = 0;

    // 敵の種類をランダムに決定
    float r = random(1);
    if (r < 0.6) {
      type = "normal";
      speed = random(2, 4);
      size = 30;
      col = color(255, 0, 0); // 赤
    } else if (r < 0.85) {
      type = "fast";
      speed = random(4, 6);
      size = 20;
      col = color(0, 150, 255); // 青
    } else {
      type = "tank";
      speed = random(1, 2);
      size = 40;
      col = color(255, 150, 0); // オレンジ
    }
  }

  void update() {
    y += speed;
  }

  void display() {
    fill(col);
    ellipse(x, y, size, size);
  }

  boolean offscreen() {
    return y > height;
  }

  int getScore() {
    if (type.equals("normal")) return 1;
    if (type.equals("fast")) return 2;
    if (type.equals("tank")) return 3;
    return 0;
  }
}
