class Bgm{
  PApplet parent;      // SoundFile生成用
  SoundFile bgm;       // BGM本体
  String    bgmPath;   // ファイルパスを保持
  float     bgmVolume = 0.5; // 音量(0.0〜1.0)
  Bgm(PApplet parent,String bgmPath){
    this.parent=parent;
    this.bgmPath=bgmPath;
    if(bgmPath!=null){
    bgm = new SoundFile(parent, bgmPath);
    bgm.amp(bgmVolume); 
   }
  }
  void soundVolume(int mode){
    if(mode==1){
      this.bgmVolume+=0.1;
    }
    else if(mode==0){
      this.bgmVolume-=0.1;
    }
    bgm.amp(this.bgmVolume);
  }
  
  void soundCheck(){
    if(this.bgmVolume<0){
      this.bgmVolume=0;
    }
    else if(this.bgmVolume>1){
      this.bgmVolume=1;
    }
    bgm.amp(this.bgmVolume);
  }
  
  void loopMusic(){
    bgm.loop();
  }
  
  void playMusic(){
    bgm.play();
  }
  
  void stopMusic(){
    bgm.stop();
  }
  
}
 
