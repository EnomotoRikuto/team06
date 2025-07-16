class Player extends Character{
  int score;
  Player(String imgpath,float x, float y,int lives){
    super(imgpath,x,y);
    this.lives=lives;
    this.score=0;
  }
  void display(){
    image(this.img,this.position.x,this.position.y,100,100);
    if(this.position.x<0){
      this.position.x=0;
    }
    else if(this.position.x>width-100){
      this.position.x=width-100;
    }
    if(this.position.y<0){
      this.position.y=0;
    }
    else if(this.position.y>height-100){
      this.position.y=height-100;
    }
      
  }
  
  void move(){
      switch(keyCode){
      case LEFT:
      this.position.x-=5;
      break;
      case RIGHT:
      this.position.x+=5;
      break;
      case UP:
      this.position.y-=5;
      break;
      case DOWN:
      this.position.y+=5;
      break;
    }
  }
  
  void colision(Character character){
    if((character.position.x-this.position.x)*(character.position.x-this.position.x)
       +(character.position.y-this.position.y)*(character.position.y-this.position.y)<1000){
       this.lives--;
  }
 }
 void colisionObstacle(Obstacle obstacle){
   if((obstacle.x-(this.position.x+50))*(obstacle.x-(this.position.x+50))
       +(obstacle.y-(this.position.y+50))*(obstacle.y-(this.position.y+50))<1000){
       this.lives--;
       }
 }
   
 boolean scoreFunc(Bullet bullet,Character character){
   if(((character.position.x+50)-bullet.x)*((character.position.x-50)-bullet.x)
       +((character.position.y+50)-bullet.y)*((character.position.y+50)-bullet.y)<1000){
    character.lives--;
    this.score+=10;
    return true;
   }
   return false;
}
 
}
