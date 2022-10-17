/*
簡易な自作関数をまとめたファイルです








*/
void keyPressed() {
}

void keyTyped() {
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

void SetStrokeColor(float gray) {
    currentStrokeColor.set(gray, gray, gray);
    fill(gray);
}

void SetStrokeColor(float v1, float v2, float v3) {
    currentStrokeColor.set(v1, v2, v3);
    fill(v1, v2 ,v3);
}

void SetStrokeWeight(float w) {
    currentStrokeWeight = w;
    strokeWeight(w);
}