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

// app.pde に、このdraw関数を丸ごと貼り付けてください

void draw() {
   println("フレーム開始時のHP: " + player.lives);
    // 1. ステージ関連の描画とゲームオーバー判定
    stage.display(player);

    // ゲームオーバー状態なら、ここで描画処理を中断
    if (stage.gameOver || stage.gameClear) {
        return;
    }

    // 2. プレイヤーの描画
    player.display();
    
    // 3. プレイヤーと障害物の当たり判定
    for (int i = 0; i < stage.obstacles.size(); i++) {
        Obstacle o = stage.obstacles.get(i);
        player.colisionObstacle(o);
    }

    // 4. プレイヤーと敵・ボスの衝突判定 (弾とは完全に独立)
    // このループは1フレームで1回だけ実行されます
    if (stage.isBossStage) {
        if (stage.boss != null) {
            player.colision(stage.boss);
        }
    } else {
        for (Enemy e : stage.enemies) {
            player.colision(e);
        }
    }

    // 5. 弾の移動と、"弾"と"敵"の当たり判定
    for (int j = 0; j < bulletArray.length; j++) {
        Bullet bullet = bulletArray[j];
        if (bullet == null) {
            continue; // 弾が存在しない場合は次の弾へ
        }

        bullet.move();

        if (!stage.isBossStage) {
            // 通常ステージ：弾と敵の当たり判定
            for (int k = stage.enemies.size() - 1; k >= 0; k--) {
                Enemy enemy = stage.enemies.get(k);
                if (player.scoreFunc(bullet, enemy)) {
                    stage.enemies.remove(k); // 敵を削除
                    bulletArray[j] = null;   // 弾を削除
                    break;                   // この弾の処理は終わり
                }
            }
        } else {
            // ボスステージ：弾とボスの当たり判定
            if (stage.boss != null) {
                if (player.scoreFunc(bullet, stage.boss)) {
                    bulletArray[j] = null; // 弾だけを削除
                }
            }
        }
    }

    // 6. ステージクリア判定
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
            // 弾配列をリセット
            for (int i = 0; i < bulletArray.length; i++) {
                bulletArray[i] = null;
            }
            bulletIndex = 0;
            // Player を復活（体力フル回復・位置リセット）
            player = new Player("宇宙船.png", 400, 300, 3);
            stage.start();
            loop();   // 描画再開
        }
    }
}