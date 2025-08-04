import java.util.ArrayList;
import processing.sound.*;   // ★ 追加

class Stage {
  // ---------- 元々のメンバ ----------
  int stageNumber;
  String gameClearPath="大勢で拍手.mp3";
  String gameOverPath="落ち込む.mp3";
  PImage background;
  ArrayList<Enemy> enemies;
  ArrayList<Obstacle> obstacles;

  boolean isBossStage;
  Boss boss;

  boolean gameOver;
  boolean gameClear;

  int btnX, btnY, btnW, btnH;

  float scrollSpeed = 2.0;
  float yOffset = 0;
  float lineSpacing = 50;
  float dashLength = 20;

  Bgm bgm,clearBgm,gameOverBgm;
 
 Stage(PApplet parent, int num, String img, String bgmPath) { // ★ コンストラクタ変更
    stageNumber = num;
    background  = loadImage(img);
    enemies     = new ArrayList<Enemy>();
    obstacles   = new ArrayList<Obstacle>();
    isBossStage = (stageNumber == 5);
    boss        = null;
    gameOver    = false;
    gameClear   = false;

    btnW = 120;
    btnH = 40;
    btnX = width/2 - btnW/2;
    btnY = height/2 + 50;
    bgm=new Bgm(parent,bgmPath);
    clearBgm=new Bgm(parent,gameClearPath);
    gameOverBgm=new Bgm(parent,gameOverPath);
  }

  void start() {
    enemies.clear();
    obstacles.clear();
    boss      = null;
    gameOver  = false;
    gameClear = false;

    // ---------- ★ BGM再生 ----------
    if (bgm != null) {
      // 念のため一度止めてから
      bgm.stopMusic();
      // ループ再生開始
      bgm.loopMusic();
    }

    println("BGM再生開始: " +bgm.bgmPath);

    if (isBossStage) {
      boss = new Boss("dog.png", width/2, -150, 1.5, 30);
    } else {
      int enemyCount = int(random(3, 6)) + stageNumber;
      for (int i = 0; i < enemyCount; i++) {
        enemies.add(createRandomEnemy());
      }
      for (int i = 0; i < 3; i++) {
        float ox = random(100, width - 140);
        float oy = random(100, height - 140);
        obstacles.add(new Obstacle(ox, oy,"隕石.png"));
      }
    }
  }

  void end() {
    println("BGM終了");
    if (bgm != null){
      bgm.stopMusic();
  }
 }

  boolean isStageClear() {
    if (isBossStage) {
      return (boss != null && boss.isDefeated());
    } else {
      return player.score >= 20;
    }
  }

  void updateScroll() {
    yOffset = (yOffset + scrollSpeed) % lineSpacing;
  }

  void display(Player player) {
    // HPチェック
    if (player.lives <= 0) {
      gameOver = true;
    }
    if (gameOver) {
      
      displayGameOver();
      return;
    }

    // ボス撃破でクリア
    if (isBossStage && boss != null && boss.isDefeated()) {
      gameClear = true;
    }
    if (gameClear) {
      displayGameClear();
      return;
    }

    updateScroll();

    // 背景描画
    if (background != null) {
      image(background, 0, 0, width, height);
    }

    // 敵・障害物・ボス描画
    if (isBossStage) {
      if (boss != null) boss.display();
    } else {
      for (int i = 0; i < enemies.size(); i++) {
        Enemy e = enemies.get(i);
        e.display(e.x, e.y);
        if (e.isOffScreen()) {
          enemies.set(i, createRandomEnemy());
        }
      }
      for (Obstacle o : obstacles) {
        o.display();
      }
    }

    // UI
    fill(255, 0, 0);
    textSize(30);
    textAlign(LEFT, TOP);
    text("STAGE: " + stageNumber, 10, 10);
    text("Score: " + player.score, 10, 40);
    text("HP: " + player.lives, 10, 70);
  }

  void displayGameOver() {
    // ★ BGM停止（必要ならフェードアウト実装可）
    if (bgm != null){
      bgm.stopMusic();
    }
    gameOverBgm.playMusic();
    fill(0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(64);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2 - 40);
    fill(200);
    rect(btnX, btnY, btnW, btnH, 8);
    fill(0);
    textSize(20);
    text("Continue", width/2, btnY + btnH/2);
    noLoop();
  }
  

  void displayGameClear() {
    // ★ BGM停止
    if (bgm != null){
      bgm.stopMusic();
    }
    clearBgm.playMusic();
    fill(0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(64);
    textAlign(CENTER, CENTER);
    text("GAME CLEAR", width/2, height/2 - 40);
    noLoop();
  }

  Enemy createRandomEnemy() {
    float speed = random(2, 6);
    if (speed <= 4) {
      return new Enemy("宇宙人1.png", speed, 80, 80);
    } else if (speed <= 5) {
      return new Enemy("宇宙人2.png", speed, 50, 50);
    } else {
      return new Enemy("宇宙人3.png", speed, 60, 60);
    }
  }
}
