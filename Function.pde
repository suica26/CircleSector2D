/*
簡易な自作関数をまとめたファイルです








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
