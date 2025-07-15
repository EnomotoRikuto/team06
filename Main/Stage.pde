import java.util.ArrayList;

class Stage {
    int stageNumber;
    PImage background;
    ArrayList<Enemy> enemies;
    ArrayList<Obstacle> obstacles;
    Object bgm;

    boolean isBossStage;
    Boss boss;

    // ゲームオーバーフラグ
    boolean gameOver;
    // ゲームクリアフラグ（追加）
    boolean gameClear;

    // Continueボタン領域
    int btnX, btnY, btnW, btnH;

    // スクロール用変数
    float scrollSpeed = 2.0;
    float yOffset = 0;
    float lineSpacing = 50;
    float dashLength = 20;

    Stage(int num, String img, Object music) {
        stageNumber = num;
        background  = loadImage(img);
        bgm         = music;
        enemies     = new ArrayList<Enemy>();
        obstacles   = new ArrayList<Obstacle>();
        isBossStage = (stageNumber == 5);
        boss        = null;
        gameOver    = false;
        // ゲームクリア初期化
        gameClear   = false;
        btnW = 120;
        btnH = 40;
        btnX = width/2 - btnW/2;
        btnY = height/2 + 50;
    }

    void start() {
        enemies.clear();
        obstacles.clear();
        boss      = null;
        gameOver  = false;
        gameClear = false;  // ステージ開始時にリセット
        println("BGMはスキップ");
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
                obstacles.add(new Obstacle(ox, oy, 50));
            }
        }
    }

    void end() {
        println("BGM終了（ダミー）");
    }

    // ステージクリア判定（変更なし）
    boolean isStageClear() {
        if (isBossStage) {
            return (boss != null && boss.isDefeated());
        } else {
            return player.score >= 20;
        }
    }

    // スクロール更新
    void updateScroll() {
        yOffset = (yOffset + scrollSpeed) % lineSpacing;
    }

    void display(Player player) {
        // 体力チェック
        if (player.lives <= 0) {
            gameOver = true;
        }
        if (gameOver) {
            displayGameOver();
            return;
        }

        // ボスステージでボス撃破したらゲームクリア
        if (isBossStage && boss != null && boss.isDefeated()) {
            gameClear = true;
        }
        if (gameClear) {
            displayGameClear();
            return;
        }

        // スクロール更新
        updateScroll();

        // 背景画像描画
        if (background != null) {
            image(background, 0, 0, width, height);
        }

        // 敵・障害物描画
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

        // UI描画（スクリーン固定）
        fill(255, 0, 0);
        textSize(30);
        textAlign(LEFT, TOP);
        text("STAGE: " + stageNumber, 10, 10);
        text("Score: " + player.score, 10, 40);
        text("HP: " + player.lives, 10, 70);
    }

    // Game Over 表示
    void displayGameOver() {
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

    // Game Clear 表示（追加）
    void displayGameClear() {
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
            return new Enemy("宇宙人1.jpg", speed, 100, 100);
        } else if (speed <= 5) {
            return new Enemy("宇宙人2.jpg", speed, 50, 50);
        } else {
            return new Enemy("宇宙人3.jpg", speed, 10, 10);
        }
    }
}
