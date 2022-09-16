/*
グローバル変数記述用ファイル








*/

ArrayList<MyObject> objects = new ArrayList<MyObject>();            //オブジェクトリスト
ArrayList<Sector2D> sectors = new ArrayList<Sector2D>();            //扇形オブジェクトリスト
ArrayList<MyBox> boxes = new ArrayList<MyBox>();                    //長方形オブジェクトリスト
ArrayList<MyCircle> circles = new ArrayList<MyCircle>();            //円形オブジェクトリスト
PVector currentFillColor = new PVector();                           //直近のfillに設定した色
float epsilon = 0.01;                                               //計算誤差補正値
float s,t;                                                          //扇形のパラメトリック表現用の変数
boolean display = true;                                             //描画切り替えフラグ
PVector[] boundingPoints = new PVector[8];                          //BV計算用頂点
MyBox AABB;                                                         //AABBボックス
Sector2D sector;

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