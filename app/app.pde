Player player;
Bullet[] bulletArray;
int  bulletIndex;
Stage stage;

void setup() {
    size(800, 600);
    // プレイヤーを初期化
    player = new Player("宇宙船.png", 400, 300, 3);
    // 弾配列
    bulletArray = new Bullet[20];
    bulletIndex = 0;
    textAlign(CENTER, CENTER);

    // ステージを初期化（引数はステージ番号、背景画像、BGMオブジェクト）
    // 背景・BGMはnullでも動作します
    stage = new Stage(1, "太陽系.jpg", null);
    stage.start();
}

// --- draw() 内の該当箇所だけ抜粋して示します ---
void draw() {

    // ステージ描画（背景・敵・障害物・UI）
    stage.display(player);
    player.display();

    // （省略：障害物との当たり判定）

    // 弾の移動と当たり判定（1体ヒットで弾も消滅）
    for (int j = 0; j < bulletArray.length; j++) {
        Bullet bullet = bulletArray[j];
        if (bullet != null) {
            bullet.move();

            if (!stage.isBossStage) {
                // 通常ステージの敵判定
                for (int k = stage.enemies.size() - 1; k >= 0; k--) {
                    Enemy enemy = stage.enemies.get(k);
                    if (enemy != null) {
                        player.colision(enemy);
                        if (player.scoreFunc(bullet, enemy)) {
                            stage.enemies.remove(k);
                            bulletArray[j] = null;
                            break;
                        }
                    }
                }

            } else {
                // ボスステージの判定
                Boss boss = stage.boss;
                if (boss != null) {
                    player.colision(boss);
                    // ダメージを与えるだけにして、boss=null は削除
                    if (player.scoreFunc(bullet, boss)) {
                        bulletArray[j] = null;
                        // ボスは内部でライフが 0 以下になれば isDefeated() が true になる想定
                        break;
                    }
                }
            }
        }
    }

    // ステージクリア判定 → 次ステージへ（ボスステージは除外）
    if (!stage.isBossStage && stage.isStageClear()) {
        player.score = 0;
        stage.end();
        stage.stageNumber++;
        switch (stage.stageNumber) {
            case 2:
                stage = new Stage(stage.stageNumber, "地球.jpg", null);
                break;
            case 3:
                stage = new Stage(stage.stageNumber, "月.jpg", null);
                break;
            case 4:
                stage = new Stage(stage.stageNumber, "火星.jpg", null);
                break;
            default:
                stage = new Stage(stage.stageNumber, "太陽.jpg", null);
                break;
        }
        stage.start();
    }
}

void keyPressed() {
    // プレイヤー移動
    player.move();

    // スペースで発射
    if (key == ' ') {
        bulletArray[bulletIndex] = new Bullet(player.position.x + 50,
                                              player.position.y);
        bulletIndex++;
        if (bulletIndex >= 20) {
            bulletIndex = 0;
        }
    }
}

// マウスクリックで Continue ボタン判定
void mousePressed() {
    // gameOver 中かつボタン内をクリックしたら再開
    if (stage.gameOver) {
        if (mouseX > stage.btnX && mouseX < stage.btnX + stage.btnW &&
            mouseY > stage.btnY && mouseY < stage.btnY + stage.btnH) {
            // Player を復活（体力フル回復・位置リセット）
            player = new Player("宇宙船.png", 400, 300, 3);
            stage.start();
            loop();   // 描画再開
        }
    }
}
