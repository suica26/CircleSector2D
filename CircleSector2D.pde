/*
メインルーチン記述用ファイル








*/

void settings() {
    size(1200,900);
}

void setup() {
    sector = new Sector2D(radians( -0),radians(0),new PVector(0,150),50,550,true,false,false);
    //オブジェクト宣言
    for (int i = 0;i < 0;i++) {
        //var sector = new Sector2D(radians(random( -90,0)),radians(random(0,90)),new PVector(0,0),random(0,100),random(100,200), true, true, true);
    }
    for (int y = 0;y <= ls;y++) {
        for (int x = 0;x <= ls;x++) {
            var box = new MyBox(new PVector( -width / 2.0 + x * width / float(ls), -height / 2.0 + y * height / float(ls)),width / float(ls),height / float(ls),true,false, false);
        }
    }
    for (int y = 0;y < 0;y++) {
        for (int x = 0;x <= 0;x++) {
            var circle = new MyCircle(new PVector( -width / 2.0 + x * width / float(ls), -height / 2.0 + y * height / float(ls)),8,true,false);
        }
    }
    
    willRotateBox = new MyBox(new PVector(300,150),500,25,false,false,false);
    RotatedBox = new MyBox(new PVector(300, 150),500,25,false,false,false);
    
    for (int i = 0;i < 4;i++) {
        AABBpoints[i] = willRotateBox.v[i];
        AABBpoints[i + 4] = RotatedBox.v[i];
    }
    
    AABB = CreateAABB(AABBpoints);
    moveFlg = false;
}


void draw() {
    translate(width / 2,height / 2);   //描画座標軸の変更
    background(255);
    fill(255);
    
    // 図形の運動
    if (moveFlg) {
        //movement();
        RotatedBox.RotateWithVec(radians( -1),new PVector(0,150));
        AdjustSector(sector, RotatedBox.angle);
        //AABBの更新
        for (int i = 0;i < 4;i++) {
            AABBpoints[i] = willRotateBox.v[i];
            AABBpoints[i + 4] = RotatedBox.v[i];
        }
        AdjustAABB(AABB,AABBpoints);
        
        if (RotatedBox.angle <= -3.14) {
            moveFlg = false;
            if (exportCSVStatus == -1) exportCSVStatus = 0;
        }
    }
    
    ArrayList<PVector> collisionPosition = new ArrayList<PVector>();
    var start = millis();
    
    //毎回ArratListのメンバ関数にアクセスする必要はないので、変数格納
    int sSize = sectors.size();
    int bSize = boxes.size();
    int cSize = circles.size();
    
    //扇形と長方形の干渉判定
    for (int i = 0;i < sSize;i++) {
        for (int j = 0;j < bSize;j++) {
            //配列の長さ取得と同様の理由
            var s = sectors.get(i);
            var b = boxes.get(j);
            if (CollisionDetection_SectorBox(s,b)) {
                collisionPosition.add(b.position);
            }
        }
    }
    
    // 扇形と円の干渉判定
    // for (int i = 0;i < sSize;i++) {
    //     for (int j = 0;j < cSize;j++) {
    //         //配列の長さ取得と同様の理由
    //         var s = sectors.get(i);
    //         var c = circles.get(j);
    //         if (CollisionDetection_SectorCircle(s,c)) {
    //             collisionPosition.add(c.position);
    //         }
    //     }
// }
    
    //長方形同士の干渉判定
    for (MyBox b : boxes) {
        if (CollisionDetection_BoxBox(AABB,b)) {
            //collisionPosition.add(b.position);
        }
    }
    
    var finish = millis();
    
    //干渉判定の実行時間(60frameに1回算出)
    if (frameCount % 60 == 0) {
        println("--------------------------------------------------------------");
        println("start:" + start);
        println("finish:" + finish);
        println("progressTime:" + (finish - start));
        println("angle:" + RotatedBox.angle);
    }
    //干渉オブジェクトの中心点を描画
    fill(0,255,0);
    for (PVector p : collisionPosition) {
        ellipse(p.x, p.y, 5, 5);
    }
    // 図形描画
    if (display) {
        for (MyObject o : objects) {
            o.DisplayShape();
        }
    }
    
    if (exportCSVStatus == 0) {
        exportCSVStatus = 1;
    }
}
