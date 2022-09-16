/*
メインルーチン記述用ファイル








*/

void settings() {
    fullScreen();
}

void setup() {
    gun = new MyBox(new PVector( -200, 0), 100, 200, 2);
    gun_front = new MyBox(new PVector( -200, 75), 100,50, 2);
    bullet = new MyCircle(new PVector(width, 0), 20, 1);
    
    xRange = width / 2;
    yRange = height / 2;
}


void draw() {
    translate(width / 2, height / 2);   //描画座標軸の変更
    background(255);
    SetFillColor(255);
    
    //銃弾の運動範囲
    boolean inXrange = bullet.position.x < xRange + 20 || bullet.position.x > - (xRange + 20);
    boolean inYrange = bullet.position.y < yRange + 20 || bullet.position.y > - (yRange + 20);
    if (inXrange && inYrange) bullet.SetPos(PVector.add(bullet.position,bulletMoveVec));
    
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
    gunDir = PVector.sub(gun.v[0], gun.v[3]);
    
    gun.SetPos(new PVector(mouseX - width / 2, mouseY - height / 2));
    gun_front.SetPos(PVector.add(gun.position,PVector.mult(gunDir.normalize(),75)));
    
    
    gun.DisplayShape(128);
    gun_front.DisplayShape(0);
    bullet.DisplayShape(255,0,0);
}
