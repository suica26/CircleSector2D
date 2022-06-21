/*
メインルーチン記述用ファイル








*/

void settings() {
    size(1200,900);
}

void setup() {
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
    /*
    for (int i = 0; i < 10;i++) {
    var box = new MyBox(new PVector(0, 0),random(20,100),random(20,100),true, true);
}
    for (int i = 0; i < 10;i++) {
    var circle = newMyCircle(new PVector(0, 0),random(10,100),true);
}
    */
    willRotateBox = new MyBox(new PVector(300,150),500,25,false,false,false);
    RotatedBox = new MyBox(new PVector(300, 150),500,25,false,false,false);
    
    for (int i = 0;i < 4;i++) {
        AABBpoints[i] = willRotateBox.v[i];
        AABBpoints[i + 4] = RotatedBox.v[i];
    }
    
    AABB = CreateAABB(AABBpoints);
}


void draw() {
    translate(width / 2,height / 2);   //描画座標軸の変更
    background(255);
    fill(255);
    
    int vl = movingObjects.size();
    int rl = rotatingObjects.size();
    // 図形の運動
    if (moveFlg) {
        //図形の平行移動
        for (int i = 0;i < vl;i++) {
            var movePos = PVector.add(movingObjects.get(i).position,moveVec.get(i));
            movingObjects.get(i).SetPos(movePos);
            if (movePos.x < - width / 2.0 || movePos.x > width / 2.0) moveVec.get(i).x *= -1;
            if (movePos.y < - height / 2.0 || movePos.y > height / 2.0) moveVec.get(i).y *= -1;
        }
        //図形の回転
        for (int j = 0;j < rl;j++) {
            rotatingObjects.get(j).Rotate(rotVec.get(j));
        }
        RotatedBox.RotateWithVec(radians( -1),new PVector(0,150));
    }
    
    //AABBの更新
    for (int i = 0;i < 4;i++) {
        AABBpoints[i] = willRotateBox.v[i];
        AABBpoints[i + 4] = RotatedBox.v[i];
    }
    AdjustAABB(AABB,AABBpoints);
    
    // 図形描画
    if (display) {
        for (MyObject o : objects) {
            o.DisplayShape();
        }
    }
    
    var start = millis();
    
    //扇形との干渉判定点
    ArrayList<PVector> checkPoints = new ArrayList<PVector>();
    //扇形との干渉内容のリスト
    IntList judgeIDs = new IntList();
    //judgeIDsに格納するための判定ID
    /*
    0 : 干渉していない
    1 : 長方形と扇形が交差
    2 : 長方形に扇形の中心点が入っている
    3 : 扇形に長方形の中心点が入っている
    4 : 円と扇形が交差
    5 : 円に扇形の中心点が入っている
    6 : 扇形に円の中心点が入っている
    */
    int judgeID = 0;
    
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
            
            //扇形と長方形が交差しているかのチェック
            var sbP = GetCrossPoints_SectorBox(s,b);
            for (PVector p : sbP) {
                judgeID = 0;//初期値化
                checkPoints.add(p);
                // 扇形内外判定
                if (CheckPointInSector(s,p))judgeID = 1;
                judgeIDs.append(judgeID);
            }
            
            // 長方形に扇形が覆われているかのチェック
            judgeID = 0;//初期値化
            checkPoints.add(s.position);
            if (CheckPointInBox(b,s.position)) judgeID = 2;
            judgeIDs.append(judgeID);
            
            // 扇形に長方形が覆われているかのチェック
            judgeID = 0;//初期値化
            checkPoints.add(b.position);
            if (CheckPointInSector(s,b.position)) judgeID = 3;
            judgeIDs.append(judgeID);
        }
    }
    
    // 扇形と円の干渉判定
    for (int i = 0;i < sSize;i++) {
        for (int j = 0;j < cSize;j++) {
            //配列の長さ取得と同様の理由
            var s = sectors.get(i);
            var c = circles.get(j);
            
            //扇形と円が交差しているかのチェック
            var scP = GetCrossPoints_SectorCircle(s,c);
            for (PVector p : scP) {
                judgeID = 0;    //初期値化
                checkPoints.add(p);
                //扇形内外判定
                if (CheckPointInSector(s,p)) judgeID = 4;
                judgeIDs.append(judgeID);
            }
            
            //円に扇形が覆われているかのチェック
            judgeID = 0;    //初期値化
            checkPoints.add(s.position);
            if (CheckPointInCircle(c,s.position)) judgeID = 5;
            judgeIDs.append(judgeID);
            
            //扇形に円が覆われているかのチェック
            judgeID = 0;    //初期値化
            checkPoints.add(c.position);
            if (CheckPointInSector(s,c.position)) judgeID = 6;
            judgeIDs.append(judgeID);
        }
    }
    
    for (MyBox b : boxes) {
        var bbP = GetCrossPoints_BoxBox(AABB,b);
        for (PVector p : bbP) {
            checkPoints.add(p);
            judgeIDs.append(1);
        }
        if (CheckPointInBox(AABB,b.position)) {
            checkPoints.add(b.position);
            judgeIDs.append(1);
        }
    }
    
    var finish = millis();
    
    //干渉判定の実行時間(60frameに1回算出)
    if (frameCount % 60 == 0) {
        println("--------------------------------------------------------------");
        println("start:" + start);
        println("finish:" + finish);
        println("progressTime:" + (finish - start));
    }
    
    //干渉点の描画
    if (display) {
        int pSize = checkPoints.size();
        for (int i = 0;i < pSize;i++) {
            int jID = judgeIDs.get(i);
            if (jID == 0) continue;
            switch(jID) {
                case 1 : fill(0,255,0); break;
                case 2 : fill(127,255,0); break;
                case 3 : fill(255,127,0); break;
                case 4 : fill(0,0,255); break;
                case 5 : fill(127,0,255); break;
                case 6 : fill(255,0,127); break;
            }
            var p = checkPoints.get(i);
            ellipse(p.x,p.y,8,8);
        }
    }
}
