/*
グローバル変数記述用ファイル








*/

ArrayList<MyObject> objects = new ArrayList<MyObject>();            //オブジェクトリスト
ArrayList<Sector2D> sectors = new ArrayList<Sector2D>();            //扇形オブジェクトリスト
ArrayList<MyBox> boxes = new ArrayList<MyBox>();                    //長方形オブジェクトリスト
ArrayList<MyCircle> circles = new ArrayList<MyCircle>();            //円形オブジェクトリスト
ArrayList<MyObject> movingObjects = new ArrayList<MyObject>();      //動くオブジェクトリスト
ArrayList<MyObject> rotatingObjects = new ArrayList<MyObject>();    //回転するオブジェクトリスト
ArrayList<PVector> moveVec = new ArrayList<PVector>();              //オブジェクトの速さリスト
FloatList rotVec = new FloatList();                                 //オブジェクトの角速度リスト
ArrayList<PVector> latticePoints = new ArrayList<PVector>();        //扇形範囲確認用の格子点リスト
float epsilon = 0.01;                                               //計算誤差補正値
float s,t;                                                          //扇形のパラメトリック表現用の変数
float velocity = 5.0;                                               //動くオブジェクトの移動速度
int moveFlg = 1;                                                    //オブジェクト動作停止用フラグ
int ls = 50;                                                        //格子のサイズ