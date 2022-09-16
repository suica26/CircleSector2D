/*
メインルーチン記述用ファイル








*/

void settings() {
    size(900,600);
    fullScreen();
}

void setup() {
    gun = new MyBox(new PVector( -200, 0), 100, 200, 2);
    gun_front = new MyBox(new PVector( -200, 75), 100,50, 2);
    bullet = new MyCircle(new PVector(width, 0), 20, 1);
    
    xRange = width / 2;
    yRange = height / 2;
    
    rotRod = new MyBox(new PVector(150, 0), 300, 20, 1);
    preRotRod = new MyBox(new PVector(150, 0), 300, 20, 0);
    
    frameRate(60);
    textSize(90);
    text_FPS = 60;
    targetFPS = text_FPS;
    
    //S-CCD用AABBの設定
    for (int i = 0; i < 4; i++) {
        AABBpoints[i] = preRotRod.v[i];
        AABBpoints[i + 4] = rotRod.v[i];
    }
    AABB = CreateAABB(AABBpoints);
}

void draw() {
    translate(width / 2, height / 2);   //描画座標軸の変更
    background(255);
    SetFillColor(255);
    
    //銃弾の運動範囲
    inXrange = bullet.position.x < xRange - 10 && bullet.position.x > - (xRange - 10);
    inYrange = bullet.position.y < yRange - 10 && bullet.position.y > - (yRange - 10);
    if (inXrange && inYrange) bullet.SetPos(PVector.add(bullet.position,PVector.mult(bulletMoveVec.normalize(),bulletSpeed / frameRate)));
    
    //銃身の回転
    if (mousePressed) {
        if (mouseButton == LEFT) {
            gun.Rotate(radians( -3), gun.position);
            gun_front.Rotate(radians( -3), gun.position);
        }
        if (mouseButton == RIGHT) {
            gun.Rotate(radians(3), gun.position);
            gun_front.Rotate(radians(3), gun.position);
        }
    }
    
    //銃身の方向
    gunDir = PVector.sub(gun.v[3], gun.v[0]);
    gun.SetPos(new PVector(mouseX - width / 2, mouseY - height / 2));
    gun_front.SetPos(PVector.add(gun.position,PVector.mult(gunDir.normalize(),75)));
    
    //回転
    preRotRod.Copy(rotRod);
    rotRod.Rotate(radians(rotSpeed / frameRate), new PVector(0, 0));
    
    //衝突判定
    switch(ccdID) {
        case 0 :
            if (CollisionDetection_BoxCircle(rotRod, bullet)) CD = true;
            break;	
        case 1 :
            for (int i = 0; i < 4; i++) {
                AABBpoints[i] = preRotRod.v[i];
                AABBpoints[i + 4] = rotRod.v[i];
            }
            AdjustAABB(AABB, AABBpoints);
            if (CollisionDetection_BoxCircle(AABB, bullet)) CD = true;
            break;
        case 2 :
            
            break;
    }
    
    //描画
    gun.DisplayShape(128);
    gun_front.DisplayShape(0);
    if (CD) bullet.DisplayShape(255,0,0);
    else bullet.DisplayShape(255,255,0);
    rotRod.DisplayShape(0,255,255);
    if (ccdID == 1) AABB.DisplayShape();
    
    //テキスト更新
    if (++timer % 5 == 0) text_FPS = int(frameRate);
    text_bulletSpeed = int(bulletSpeed);
    text_rotSpeed = int(rotSpeed);
    
    //テキストUI
    if (changeID == 0) fill(255, 0, 0);
    else fill(15);
    text("FPS:", -width / 2 + 50, -height / 2 + 100);
    text(text_FPS, -width / 2 + 230, -height / 2 + 100);
    
    if (changeID == 1) fill(255, 0, 0);
    else fill(15);
    text("btSpeed:", -width / 2 + 50, -height / 2 + 200);
    text(text_bulletSpeed, -width / 2 + 400, -height / 2 + 200);
    
    if (changeID == 2) fill(255, 0, 0);
    else fill(15);
    text("rotSpeed:", -width / 2 + 50, -height / 2 + 300);
    text(text_rotSpeed, -width / 2 + 430, -height / 2 + 300);
    
    if (changeID == 3) fill(255, 0, 0);
    else fill(15);
    text("CCD:", -width / 2 + 50, -height / 2 + 400);
    text(text_CCD, -width / 2 + 240, -height / 2 + 400);
}
