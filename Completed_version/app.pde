Player player;
Bullet[] bulletArray;
int  bulletIndex;
Stage stage;
SoundFile hitSfx,bulletSfx;

void setup() {
    size(800, 600);
    // プレイヤーを初期化
    player = new Player("宇宙船.png", 400, 300, 3);
    // 弾配列
    bulletArray = new Bullet[20];
    bulletIndex = 0;
    textAlign(CENTER, CENTER);
    // ステージを初期化
    stage = new Stage(this, 1, "太陽系.jpg", "maou_bgm_8bit29.mp3");
    hitSfx = new SoundFile(this, "キャンセル3.mp3");
    bulletSfx=new SoundFile(this,"ビームガン.mp3");
    player.setSound(hitSfx,bulletSfx);
    stage.start();
}

void draw() {
    // デバッグ用: フレーム開始時のHPを表示
    println("フレーム開始時のHP: " + player.lives);
    println("BGMの音量:"+stage.bgm.bgmVolume);

    // 1. ステージ関連の描画（背景、敵、UIなど）とゲームオーバー判定
    stage.display(player);

    // ゲームオーバーまたはゲームクリア状態なら、ここで描画処理を中断
    if (stage.gameOver || stage.gameClear) {
        return;
    }

    // 2. プレイヤーの描画
    player.display();
    
    // 3. プレイヤーと障害物の当たり判定
    for (Obstacle o : stage.obstacles) {
      player.colisionObstacle(o);
    }

    // 4. プレイヤーと敵・ボスの衝突判定 (弾とは独立)
    if (stage.isBossStage) {
        if (stage.boss != null) {
            player.colision(stage.boss);
        }
    } else {
        for (Enemy e : stage.enemies) {
            player.colision(e);
        }
    }
    
    // 5. プレイヤーとボスの弾の当たり判定
    if (stage.isBossStage && stage.boss != null) {
      for (int i = stage.boss.bullets.size() - 1; i >= 0; i--) {
        BossBullet b = stage.boss.bullets.get(i);
        if (player.colisionBossBullet(b)) {
          stage.boss.bullets.remove(i);
        }
      }
    }

    // 6. 弾の移動と、"弾"と"敵"の当たり判定
    for (int j = 0; j < bulletArray.length; j++) {
        Bullet bullet = bulletArray[j];
        if (bullet == null) {
            continue;
        }

        bullet.move();

        if (!stage.isBossStage) {
            // 通常ステージ：弾と敵の当たり判定
            for (int k = stage.enemies.size() - 1; k >= 0; k--) {
                Enemy enemy = stage.enemies.get(k);
                if (player.scoreFunc(bullet, enemy)) {
                    stage.enemies.remove(k);
                    bulletArray[j] = null;
                    break;
                }
            }
        } else {
            // ボスステージ：弾とボスの当たり判定
            if (stage.boss != null) {
                if (player.scoreFunc(bullet, stage.boss)) {
                    bulletArray[j] = null;
                }
            }
        }
    }

    // 7. ステージクリア判定
    if (!stage.isBossStage && stage.isStageClear()) {
        player.score = 0;
        stage.end();
        stage.stageNumber++;
        switch (stage.stageNumber) {
            case 2:
                stage = new Stage(this,stage.stageNumber, "地球.jpg","maou_bgm_8bit27.mp3");
                break;
            case 3:
                stage = new Stage(this,stage.stageNumber, "月.jpg","maou_bgm_8bit25.mp3");
                break;
            case 4:
                stage = new Stage(this,stage.stageNumber, "火星.jpg", "maou_bgm_8bit23.mp3");
                break;
            default:
                stage = new Stage(this,stage.stageNumber, "太陽.jpg", "maou_bgm_8bit21.mp3");
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
    else if(key=='u'){
      stage.bgm.soundVolume(1);
    }
    else if(key=='d'){
      stage.bgm.soundVolume(0);
    }
    stage.bgm.soundCheck();
}

// マウスクリックで Continue ボタン判定
void mousePressed() {
    if (stage.gameOver) {
        if (mouseX > stage.btnX && mouseX < stage.btnX + stage.btnW &&
            mouseY > stage.btnY && mouseY < stage.btnY + stage.btnH) {
            
            // 弾配列をリセット
            for (int i = 0; i < bulletArray.length; i++) {
                bulletArray[i] = null;
            }
            bulletIndex = 0;

            // Player を復活
            player = new Player("宇宙船.png", 400, 300, 3);
            hitSfx = new SoundFile(this,"キャンセル3.mp3");
            bulletSfx=new SoundFile(this,"ビームガン.mp3");
            player.setSound(hitSfx,bulletSfx);
            if(stage.gameOverBgm!=null){
              stage.gameOverBgm.stopMusic();
            }
            stage.start();
            loop();   // 描画再開
        }
    }
}
