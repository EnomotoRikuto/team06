class Obstacle {
  float x, y;
  int r;

  Obstacle(float x_, float y_,int r) {
    x = x_;
    y = y_;
    this.r=r;
  }

  void display() {
    fill(100, 200, 100);
    ellipse(x, y, 3*r,r);
  }
}
