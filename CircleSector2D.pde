/*
メインルーチン記述用ファイル








*/

void settings() {
    size(1200,900);
}

void setup() {
    sector = new Sector2D(new PVector(0, 0), radians(0), radians(60), 100, 300);
    box = new MyBox(new PVector( -200, 0), 100, 200);
    circle = new MyCircle(new PVector(200, 0), 50);
}


void draw() {
    translate(width / 2, height / 2);   //描画座標軸の変更
    background(255);
    fill(255);
    
    box.Rotate(radians(1), new PVector(0, 0));
    circle.Rotate(radians(1), new PVector(0, 0));
    
    fill(255, 255, 0, 255);
    sector.DisplayShape();
    box.DisplayShape();
    circle.DisplayShape();
}
