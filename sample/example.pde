// ==================== 新しく追加・変更した変数 ====================
final int SCORE_PER_STAGE = 50;   // ステージクリアに必要なスコア
int stage = 1;                     // 現在のステージ番号
boolean stageCleared = false;      // ステージクリア中か
int stageClearTimer = 0;           // クリア演出残りフレーム数

// 敵の出現間隔（ステージが上がるほど短くなる）
int enemySpawnMin = 60;
int enemySpawnMax = 120;
// ===============================================================

Player player;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
int enemySpawnTimer = 0;
int score = 0;
float scrollY = 0;
int lives = 3;
boolean gameOver = false;

void setup() {
  size(400, 600);
  player  = new Player();
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();
  textSize(20);
}

void draw() {
  background(0);

  // 背景スクロール
  scrollY += 2;
  for (int i = 0; i < height; i += 40) {
    stroke(50);
    line(0, (i + int(scrollY)) % height, width, (i + int(scrollY)) % height);
  }

  // スコア・ライフ・ステージ表示
  fill(255);
  text("Stage: " + stage, 10,  25);
  text("Score: " + score, 10,  50);
  text("Lives: " + lives, 10,  75);

  // --------------- ゲームオーバー ----------------
  if (gameOver) {
    showCenterMessage("GAME OVER", color(255, 0, 0));
    return;
  }

  // --------------- ステージクリア演出 -------------
  if (stageCleared) {
    showCenterMessage("STAGE " + stage + " CLEAR!", color(0, 255, 0));
    if (--stageClearTimer <= 0) nextStage();     // 演出終了で次ステージへ
    return;
  }

  // --------------- 通常ゲーム処理 -----------------
  player.update();
  player.display();

  // 弾の処理
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.offscreen()) bullets.remove(i);
  }

  // 敵の出現処理
  if (enemySpawnTimer <= 0) {
    enemies.add(new Enemy());
    enemySpawnTimer = int(random(enemySpawnMin, enemySpawnMax));
  } else {
    enemySpawnTimer--;
  }

  // 敵の更新・当たり判定
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    if (e.offscreen()) {
      enemies.remove(i);
      continue;
    }

    // 弾と敵
    for (int j = bullets.size() - 1; j >= 0; j--) {
      Bullet b = bullets.get(j);
      if (dist(e.x, e.y, b.x, b.y) < e.size / 2 + 5) {
        score += e.getScore();
        enemies.remove(i);
        bullets.remove(j);
        checkStageClear();            // ★ ステージクリア判定
        break;
      }
    }

    // 敵とプレイヤー
    if (dist(e.x, e.y, player.x, player.y) < e.size / 2 + 15) {
      enemies.remove(i);
      lives--;
      if (lives <= 0) gameOver = true;
    }
  }
}

void keyPressed() {
  if (gameOver || stageCleared) return;   // クリア演出中も入力無効化

  if (keyCode == LEFT)       player.moveX(-1);
  else if (keyCode == RIGHT) player.moveX(1);
  else if (keyCode == UP)    player.moveY(-1);
  else if (keyCode == DOWN)  player.moveY(1);
  else if (key == ' ')       bullets.add(new Bullet(player.x, player.y));
}

// ---------- ステージクリア判定 ----------
void checkStageClear() {
  if (score >= stage * SCORE_PER_STAGE) {
    stageCleared   = true;
    stageClearTimer = 120;   // 2 秒 (60fps 前提)
    enemies.clear();
    bullets.clear();
  }
}

// ---------- 次ステージの初期化 ----------
void nextStage() {
  stageCleared = false;
  stage++;                 // ステージ番号アップ

  // 難易度調整（出現間隔を短縮。ただし下限を設ける）
  enemySpawnMin = max(20, enemySpawnMin - 5);
  enemySpawnMax = max(40, enemySpawnMax - 5);

  enemySpawnTimer = 0;     // すぐに次の敵を出現させる
}

// ---------- 中央メッセージ描画 ----------
void showCenterMessage(String msg, color c) {
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(c);
  text(msg, width / 2, height / 2);
  textAlign(LEFT, BASELINE);
  textSize(20);
}
