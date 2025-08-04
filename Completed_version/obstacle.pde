class Obstacle {
  PImage obs;
  float x, y;
  Obstacle(float x, float y,String obs_path) {
    this.x=x;
    this.y=y;
    obs=loadImage(obs_path);
  }
  void display() {
    image(obs,x,y,100,100);
  }
}
