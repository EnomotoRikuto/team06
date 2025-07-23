import java.util.ArrayList;
import processing.sound.*;   // ★ 追加

class Stage {
  // ---------- 元々のメンバ ----------
  int stageNumber;
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

  // ---------- ★ 追加/変更部分 ----------
  PApplet parent;      // SoundFile生成用
  SoundFile bgm;       // BGM本体
  String    bgmPath;   // ファイルパスを保持
  float     bgmVolume = 0.5; // 音量(0.0〜1.0)

  Stage(PApplet parent, int num, String img, String bgmPath) { // ★ コンストラクタ変更
    this.parent = parent;
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

    this.bgmPath = bgmPath;
    if (bgmPath != null) {
      bgm = new SoundFile(parent, bgmPath);
      bgm.amp(bgmVolume);
    }
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
      bgm.stop();
      // ループ再生開始
      bgm.loop();
    }

    println("BGM再生開始: " + bgmPath);

    if (isBossStage) {
      boss = new Boss("dog.png", width/2, -150, 1.5, 30);
    } else {
      int enemyCount = int(random(3, 6)) + stageNumber;
      for (int i = 0; i < enemyCount; i++) {
        enemies.add(createRandomEnemy());
      }
      int obstacleCount = 3 + stageNumber - 1;  // ステージ1→3個、ステージ2→4個、ステージ3→5個…
for (int i = 0; i < obstacleCount; i++) {
    float ox = random(100, width - 140);
    float oy = random(100, height - 140);
    obstacles.add(new Obstacle(ox, oy, 50));
}
    }
  }

  void end() {
    println("BGM終了");
    if (bgm != null) bgm.stop();
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
    if (bgm != null) bgm.stop();

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
    if (bgm != null) bgm.stop();

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
