/*
2022紅華祭用の関数です。

マウスボタン：筒を回転
Spaceキー：弾を発射
矢印キー：パラメータ操作
1, 2, 3, 4番キー：パラメータ変更速度変更
pキー：長方形の回転停止/開始
dキー：CCD図形の描画切り替え


*/
/*
PVector mousePos = new PVector();

MyBox gun;
MyBox gun_front;
PVector gunDir = new PVector();

MyCircle bullet;
PVector bulletMoveVec = new PVector();

MyBox rotRod;
MyBox preRotRod;
boolean CD = false;

float xRange, yRange;
boolean inXrange, inYrange;

int changeID;
int paramChangeValue = 1;
int timer = 0;

int targetFPS = 60;
float bulletSpeed = 1000;
float rotSpeed = 300;
int ccdID;

int text_FPS;
int text_bulletSpeed;
int text_rotSpeed;
String text_CCD = "なし";

boolean moveFlg = true;
boolean ccdDispFlg = false;

void tutfes_setup() {
PFont font = createFont("Meiryo", 50);
textFont(font);

gun = new MyBox(new PVector( -200, 0), 100, 200, 2);
gun_front = new MyBox(new PVector( -200, 75), 100,50, 2);
bullet = new MyCircle(new PVector(width, 0), 20, 1);

xRange = width / 2;
yRange = height / 2;

rotRod = new MyBox(new PVector(200, 0), 350, 20, 1);
preRotRod = new MyBox(new PVector(200, 0), 350, 20, 0);

frameRate(60);
textSize(90);
text_FPS = 60;
targetFPS = text_FPS;

//S-CCD用AABBの設定
for (int i = 0; i < 4; i++) {
boundingPoints[i] = preRotRod.v[i];
boundingPoints[i + 4] = rotRod.v[i];
    }
AABB = CreateAABB(boundingPoints);
sector = new Sector2D(new PVector(0, 0), 0, 0, 25, 375, 3);
}

void tutfes_draw() {
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
if (moveFlg) {
preRotRod.Copy(rotRod);
rotRod.Rotate(radians(rotSpeed / frameRate), new PVector(0, 0));
    }

//衝突判定
switch(ccdID) {
case 0 :
if (CollisionDetection_BoxCircle(rotRod, bullet)) CD = true;
break;	
case 1 :
for (int i = 0; i < 4; i++) {
boundingPoints[i] = preRotRod.v[i];
boundingPoints[i + 4] = rotRod.v[i];
}
AdjustAABB(AABB, boundingPoints);
if (CollisionDetection_BoxCircle(AABB, bullet)) CD = true;
break;
case 2 :
AdjustSector(sector, preRotRod.angle, rotRod.angle, 25, 375);
if (CollisionDetection_SectorCircle(sector, bullet) || CollisionDetection_BoxCircle(rotRod, bullet)) CD = true;
break;
    }

//描画
gun.DisplayShape(128);
gun_front.DisplayShape(0);

if (CD) bullet.DisplayShape(255, 0, 0, 255);
else bullet.DisplayShape(255, 255, 0, 255);

rotRod.DisplayShape(0,255,255);
if (ccdDispFlg) {
if (ccdID >= 1) preRotRod.DisplayShape();
if (ccdID == 1) AABB.DisplayShape(255, 0, 0, 63);
if (ccdID == 2) sector.DisplayShape(255, 0, 0, 63);
    }

//テキスト更新
if (++timer % 5 == 0) text_FPS = int(frameRate);
text_bulletSpeed = int(bulletSpeed);
text_rotSpeed = int(rotSpeed);

//テキストUI
fill(15);
text("数値変化量:", -width / 2 + 50, height / 2 - 50);
text(paramChangeValue, -width / 2 + 530, height / 2 - 50);

if (changeID == 0) fill(255, 0, 0);
else fill(15);
text("FPS:", -width / 2 + 50, -height / 2 + 100);
text(text_FPS, -width / 2 + 250, -height / 2 + 100);

if (changeID == 1) fill(255, 0, 0);
else fill(15);
text("弾速:", -width / 2 + 50, -height / 2 + 200);
text(text_bulletSpeed, -width / 2 + 260, -height / 2 + 200);

if (changeID == 2) fill(255, 0, 0);
else fill(15);
text("回転速度:", -width / 2 + 50, -height / 2 + 300);
text(text_rotSpeed, -width / 2 + 450, -height / 2 + 300);

if (changeID == 3) fill(255, 0, 0);
else fill(15);
text("CCD:", -width / 2 + 50, -height / 2 + 400);
text(text_CCD, -width / 2 + 270, -height / 2 + 400);
}

void tutfes_keyPressed() {
//銃弾装填
if (key == ' ' && !(inXrange && inYrange)) {
bullet.SetPos(gun_front.position);
bulletMoveVec.set(gunDir.x, gunDir.y);
CD = false;
    }

//パラメーター降下
if (keyCode == LEFT) {
switch(changeID) {
case 0 :
targetFPS -= paramChangeValue;
if (targetFPS < 1) targetFPS = 1;
frameRate(targetFPS);
break;
case 1 :
bulletSpeed -= paramChangeValue;
if (bulletSpeed < 1) bulletSpeed = 1;
break;
case 2 :
rotSpeed -= paramChangeValue;
if (rotSpeed < 1) rotSpeed = 1;
break;
case 3 :
if (--ccdID < 0) ccdID = 0;
switch(ccdID) {
case 0 : text_CCD = "なし"; break;	
case 1 : text_CCD = "S-CCD"; break;
case 2 : text_CCD = "扇形"; break;
}
break;
}
    }

//パラメーター上昇
if (keyCode == RIGHT) {
switch(changeID) {
case 0 :
targetFPS += paramChangeValue;
if (targetFPS > 240) targetFPS = 240;
frameRate(targetFPS);
break;
case 1 :
bulletSpeed += paramChangeValue;
if (bulletSpeed > 10000) bulletSpeed = 1000;
break;
case 2 :
rotSpeed += paramChangeValue;
if (rotSpeed > 10000) rotSpeed = 180;
break;
case 3 :
if (++ccdID > 2) ccdID = 2;
switch(ccdID) {
case 0 : text_CCD = "なし"; break;	
case 1 : text_CCD = "S-CCD"; break;
case 2 : text_CCD = "扇形"; break;
}
break;
}
    }

//変更するパラメーターを選択
if (keyCode == UP) if (--changeID < 0) changeID = 0;

if (keyCode == DOWN) if (++changeID > 3) changeID = 3;
}

void tutfes_keyTyped() {
if (key == 'p') moveFlg = !moveFlg;
if (key == 'd') ccdDispFlg = !ccdDispFlg;

if (key == '1') paramChangeValue = 1;
if (key == '2') paramChangeValue = 10;
if (key == '3') paramChangeValue = 100;
if (key == '4') paramChangeValue = 1000;
}
*/