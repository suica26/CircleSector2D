//alphaは回転前の角度
//thetaは回転後の角度
float alpha, theta;
//r1はa,adを通る円の半径(短)
//r2はb,bdを通る円の半径(長)
float r1,r2;
//回転中心の位置ベクトル
PVector origin;
//a,bは回転前の位置ベクトル
//ad,bdは回転後の位置ベクトル
PVector a,b,ad,bd;


void settings() {
    size(800,800);
}

void setup() {
    alpha = PI * 0 / 180;
    theta = PI * 120 / 180;
    r1 = 100;
    r2 = 300;
    
    origin = new PVector(0,0);
    
    a = new PVector(r1 * cos(alpha), r1 * sin(alpha));
    b = new PVector(r2 * cos(alpha), r2 * sin(alpha));
    ad = new PVector(r1 * cos(theta), r1 * sin(theta));
    bd = new PVector(r2 * cos(theta), r2 * sin(theta));
}

void draw() {
    translate(width / 2, height / 2);
    background(255);
    fill(255);
    
    arc(origin.x, origin.y, r2 * 2, r2 * 2, alpha, theta);
    arc(origin.x, origin.y, r1 * 2, r1 * 2, alpha, theta);
    line(a.x, a.y, b.x, b.y); //回転前の線分
    line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
}

//2D扇形
public class CircleSegment2D {
    //alphaは回転前の角度
    //thetaは回転後の角度
    float alpha, theta;
    //r1はa,adを通る円の半径(短)
    //r2はb,bdを通る円の半径(長)
    float r1,r2;
    //回転中心の位置ベクトル
    PVector origin;
    //a,bは回転前の位置ベクトル
    //ad,bdは回転後の位置ベクトル
    PVector a,b,ad,bd;
    
    public CircleSegment2D(float alpha, float theta, PVector origin, float radius1, float radius2) {
        
    }
    
}
