/*
関数記述用ファイル








*/
void keyPressed() {
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

void keyTyped() {
    if (key == 'p') moveFlg = !moveFlg;
    if (key == 'd') ccdDispFlg = !ccdDispFlg;
    
    if (key == '1') paramChangeValue = 1;
    if (key == '2') paramChangeValue = 10;
    if (key == '3') paramChangeValue = 100;
    if (key == '4') paramChangeValue = 1000;
}

// 外積関数
float Cross(PVector a, PVector b) {
    return a.x * b.y - a.y * b.x;
}

// 回転行列
PVector RotateMatrix(float theta, PVector v) {
    float x = v.x * cos(theta) - v.y * sin(theta);
    float y = v.x * sin(theta) + v.y * cos(theta);
    return new PVector(x,y);
}

// 扇形関数 P(s,t) = R(tθ)L(s) + O
//次の条件の時、扇形の中の点を返す
//0 <= s <= 1
//0 <= t <= 1
PVector SectorPoint(Sector2D f, float s, float t) {
    PVector v = PVector.add(PVector.sub(f.a,f.origin),PVector.mult(PVector.sub(f.b,f.a),s));
    PVector p = PVector.add(RotateMatrix(t * (f.theta - f.alpha),v),f.origin);
    return p;
}

MyBox CreateAABB(PVector[] points) {
    //最小、最大の座標を計算する
    float mX,MX,mY,MY;
    mX = 10000;
    MX = -10000;
    mY = 10000;
    MY = -10000;
    
    for (PVector p : points) {
        if (mX >= p.x) mX = p.x;
        if (MX <= p.x) MX = p.x;
        if (mY >= p.y) mY = p.y;
        if (MY <= p.y) MY = p.y;
    }
    
    return new MyBox(new PVector((MX + mX) / 2.0,(MY + mY) / 2.0),MX - mX,MY - mY, 3);
}

void AdjustAABB(MyBox b, PVector[] points) {
    //最小、最大の座標を計算する
    float mX,MX,mY,MY;
    mX = 10000;
    MX = -10000;
    mY = 10000;
    MY = -10000;
    
    for (PVector p : points) {
        if (mX >= p.x) mX = p.x;
        if (MX <= p.x) MX = p.x;
        if (mY >= p.y) mY = p.y;
        if (MY <= p.y) MY = p.y;
    }
    
    b.position.set((MX + mX) / 2,(MY + mY) / 2);
    b.w = MX - mX;
    b.h = MY - mY;
    b.v[0].set(b.position.x + b.w / 2, b.position.y + b.h / 2);
    b.v[1].set(b.position.x - b.w / 2, b.position.y + b.h / 2);
    b.v[2].set(b.position.x - b.w / 2, b.position.y - b.h / 2);
    b.v[3].set(b.position.x + b.w / 2, b.position.y - b.h / 2);
    b.angle = 0;
}

void AdjustSector(Sector2D s, float t) {
    s.alpha = t;
    s.a.set(s.r1 * cos(s.alpha) + s.origin.x, s.r1 * sin(s.alpha) + s.origin.y);
    s.b.set(s.r2 * cos(s.alpha) + s.origin.x, s.r2 * sin(s.alpha) + s.origin.y);
    s.ad.set(s.r1 * cos(s.theta) + s.origin.x, s.r1 * sin(s.theta) + s.origin.y);
    s.bd.set(s.r2 * cos(s.theta) + s.origin.x, s.r2 * sin(s.theta) + s.origin.y);
    s.position = PVector.mult(PVector.add(PVector.sub(s.a,s.origin),PVector.sub(s.ad,s.origin)).normalize(),(s.r2 + s.r1) / 2.0);
}

void AdjustSector(Sector2D s, float alpha, float theta, float r1, float r2) {
    s.alpha = alpha;
    s.theta = theta;
    s.r1 = r1;
    s.r2 = r2;
    
    s.a.set(s.r1 * cos(s.alpha) + s.origin.x, s.r1 * sin(s.alpha) + s.origin.y);
    s.b.set(s.r2 * cos(s.alpha) + s.origin.x, s.r2 * sin(s.alpha) + s.origin.y);
    s.ad.set(s.r1 * cos(s.theta) + s.origin.x, s.r1 * sin(s.theta) + s.origin.y);
    s.bd.set(s.r2 * cos(s.theta) + s.origin.x, s.r2 * sin(s.theta) + s.origin.y);
    s.position = PVector.mult(PVector.add(PVector.sub(s.a,s.origin),PVector.sub(s.ad,s.origin)).normalize(),(s.r2 + s.r1) / 2.0);
}

/////////////////////////////////////////////////////////////////
/*
draw内関数
*/

void SetFillColor(float gray) {
    currentFillColor.set(gray, gray, gray);
    fill(gray);
}

void SetFillColor(float v1, float v2, float v3) {
    currentFillColor.set(v1, v2, v3);
    fill(v1, v2 ,v3);
}
