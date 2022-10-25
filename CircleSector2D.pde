/*
メインルーチン記述用ファイルです



*/

void settings() {
    fullScreen();
}

void setup() {
    circle = new MyCircle(new PVector(200, 200), 50, 1);
    capsule = new MyCapsule(new PVector(100, 100), new PVector( -100, -100), 50, 1);
    cap2 = new MyCapsule(new PVector(0, 100), new PVector(0, -100), 30, 1);
    SetStrokeWeight(1);
}

void draw() {
    translate(width / 2, height / 2);   //描画座標軸の変更
    background(255);
    
    //capsule.Rotate(radians(3), capsule.position);
    
    if (mousePressed) {
        m.set(mouseX - width / 2, mouseY - height / 2);
        cap2.SetPos(m);
    }
    
    capsule.DisplayShape(128);
    
    if (CollisionDetection_CapsuleCapsule(capsule, cap2))
        cap2.DisplayShape();
    else
        cap2.DisplayShape(255, 255, 0, 255);
}