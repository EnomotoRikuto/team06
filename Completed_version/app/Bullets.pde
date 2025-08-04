class Bullet{
  float x,y;
  float dy=7;
  Bullet(float x ,float y){
    this.x=x;
    this.y=y;
  }
  
  void move(){
    fill(255,255,0);
    ellipse(x,y,20,20);
    y-=dy;
  }
  
}
  
  
    
    
