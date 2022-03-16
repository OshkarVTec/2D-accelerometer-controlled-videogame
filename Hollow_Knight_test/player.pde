class Player {
  int x,y;
    int width_p;
  float xSpeed,ySpeed;
  float accel,deccel;
  float maxXspd,maxYspd;
  
  float alt_xSpeed,alt_ySpeed;
  float alt_accel,alt_deccel;
  float alt_maxXspd, alt_maxYspd;
  
  float state;
  float alt_state;
  float stateRate;
  int side_flag;
  
  float xSave,ySave;
  int xRep,yRep;
  float gravity;
  
  PImage leftA;
  PImage leftB;
  PImage leftC;
  PImage leftD;
  PImage leftE;
  PImage leftF;
  PImage leftG;
  
  PImage rightA;
  PImage rightB;
  PImage rightC;
  PImage rightD;
  PImage rightE;
  PImage rightF;
  PImage rightG;
  
  PImage alt_leftA;
  PImage alt_leftB;
  PImage alt_leftC;
  PImage alt_leftD;
  PImage alt_leftE;
  PImage alt_leftF;
  PImage alt_leftG;
  
  PImage alt_rightA;
  PImage alt_rightB;
  PImage alt_rightC;
  PImage alt_rightD;
  PImage alt_rightE;
  PImage alt_rightF;
  PImage alt_rightG;
  
  Player(int _x, int _y, int _width_p) {
    x = _x;
    y = _y;
    width_p = _width_p;
    xSpeed = 0;
    ySpeed = 0;
    accel = 0.5;
    deccel = 0.4;
    maxXspd = 6;
    maxYspd = 12;
    
    //Elementos forma Alterna
    alt_xSpeed = 0;
    alt_ySpeed = 0;
    alt_accel = 1.0;
    alt_deccel = 0.8;
    alt_maxXspd = 12;
    alt_maxYspd =12;
    
    //Elementos cambio de estados-Animaciones
    state = 0;
    alt_state = 20;
    stateRate = .1;
    side_flag=1;
    
    //elementos IDK
    xSave = 0;
    ySave = 0;
    xRep = 0;
    yRep = 0;
    gravity = 0.2;
 
    //Imagenes para las animaciones
    leftA = loadImage("left_move_1.png");
    leftB = loadImage("left_move_2.png");
    leftC = loadImage("left_move_3.png");
    leftD = loadImage("left_move_4.png");
    leftE = loadImage("left_move_5.png");
    leftF = loadImage("left_move_6.png");
    leftG = loadImage("left_move_7.png");
    
    rightA = loadImage("right_move_1.png");
    rightB = loadImage("right_move_2.png");
    rightC = loadImage("right_move_3.png");
    rightD = loadImage("right_move_4.png");
    rightE = loadImage("right_move_5.png");
    rightF = loadImage("right_move_6.png");
    rightG = loadImage("right_move_7.png");
    
    alt_leftA = loadImage("left_crouch_1.png");
    alt_leftB = loadImage("left_crouch_2.png");
    alt_leftC = loadImage("left_crouch_3.png");
    alt_leftD = loadImage("left_crouch_4.png");
    alt_leftE = loadImage("left_crouch_5.png");
    alt_leftF = loadImage("left_crouch_6.png");
    alt_leftG = loadImage("left_crouch_7.png");
    
    alt_rightA = loadImage("right_crouch_1.png");
    alt_rightB = loadImage("right_crouch_2.png");
    alt_rightC = loadImage("right_crouch_3.png");
    alt_rightD = loadImage("right_crouch_4.png");
    alt_rightE = loadImage("right_crouch_5.png");
    alt_rightF = loadImage("right_crouch_6.png");
    alt_rightG = loadImage("right_crouch_7.png");
  }
 //------------------------------------------------------------------------------------------- 
  void update() {

    if ( right ) {
      xSpeed += accel;
      side_flag=1;
      
      //Tope del personaje lateral derecho
       if (x > (width_p-80)){
         x = width_p-80;
       }
      //Tope del personaje lateral izquierdo
       if (x < 0){
         x = 0;
       }
       
      if ( xSpeed > maxXspd ) {
        xSpeed = maxXspd;
      }
      //Cambio de estados-Animaciones
      state = state + (stateRate*2);
            if (state >8) {
            state = 1.1;
           }
    }
    
    else if ( left ) {
      xSpeed -= accel;
      side_flag=0;
      
       //Tope del personaje lateral derecho
        if (x > (width_p-80)){
         x = width_p-80;
       }
       //Tope del personaje lateral izquierdo
       if (x < 0){
         x = 0;
       }
       
      if ( xSpeed < -maxXspd ) {
        xSpeed = -maxXspd;
      }
      //Cambio de estados-Animaciones
      state = state - (stateRate*2);
            if (state <-7) {
            state = -0.1;
           }
    }
    
    else { //neither right or left pressed, decelerate
    if (side_flag == 0){
      state = 0;
         if ( xSpeed < 0 ) {
        xSpeed += deccel;
        if ( xSpeed > 0 ) {
          xSpeed = 0;
          }
        }
    }
    if (side_flag ==1){
      state = 1;
      if ( xSpeed > 0 ) {
        xSpeed -= deccel;
        if ( xSpeed < 0 ) {
           xSpeed = 0;
        }
      }
      }
    }
     
    if ( up ) {    
      if ( !place_free(x,y+80)  || !place_free(x+79,y+80)) {
        ySpeed = -6.3;
      }
    }
    ySpeed += gravity;
    
    
    xRep = 0; 
    yRep = 0;
    xRep += floor(abs(xSpeed));
    yRep += floor(abs(ySpeed));
    xSave += abs(xSpeed)-floor(abs(xSpeed));
    ySave += abs(ySpeed)-floor(abs(ySpeed));
    int signX = (xSpeed<0) ? -1 : 1;
    int signY = (ySpeed<0) ? -1 : 1;   
     //println("X is: " + x);
     //println("Y is: " + y);
     //println("Alt state is: " + alt_state);
     //println("alt_xSpeed: "+ alt_xSpeed);
 
             
    int offsetX = (xSpeed<0) ? 0 : 79;
    int offsetY = (ySpeed<0) ? 0 : 79; 
    
    if ( xSave >= 1 ) {
      xSave -= 1;
      xRep++;
    }
    if ( ySave >= 1 ) {
      ySave -= 1;
      yRep++;
    }
    
    
    for ( ; yRep > 0; yRep-- ) {
      if ( place_free(x,y+offsetY) && place_free(x+79,y+offsetY+signY)) {
        y += signY;
      }
      else {
        ySpeed = 0;
      }
    }
    
    
     for ( ; xRep > 0; xRep-- ) {
      if ( place_free(x+offsetX+signX,y) && place_free(x+offsetX+signX,y+79) ) {
        x += signX;
      }
      else {
        xSpeed = 0;
      } 
    }
  }
  
   void show() {
    pushMatrix();
    noFill();
    stroke(255);
    rect(x,y,80,80);
    popMatrix();
  }
  //------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------- 
  void alt_update() {

    if ( right ) {
      alt_xSpeed += alt_accel;
      side_flag=1;
      
      //Tope del personaje lateral derecho
       if (x > (width_p-80)){
         x = width_p-80;
       }
      //Tope del personaje lateral izquierdo
       if (x < 0){
         x = 0;
       }
       
      if ( alt_xSpeed > maxXspd ) {
        alt_xSpeed = maxXspd;
      }
      //Cambio de estados-Animaciones
      alt_state = alt_state + (stateRate*2);
            if (alt_state >28) {
            alt_state = 21.1;
           }
    }
    
    else if ( left ) {
      alt_xSpeed -= alt_accel;
      side_flag=0;
      
       //Tope del personaje lateral derecho
        if (x > (width_p-80)){
         x = width_p-80;
       }
       //Tope del personaje lateral izquierdo
       if (x < 0){
         x = 0;
       }
       
      if ( alt_xSpeed < -maxXspd ) {
        alt_xSpeed = -maxXspd;
      }
      //Cambio de estados-Animaciones
      alt_state = alt_state - (stateRate*2);
            if (alt_state <13) {
            alt_state = 19.9;
           }
    }
    
    else { //neither right or left pressed, decelerate
    if (side_flag == 0){
      alt_state = 20;
         if ( alt_xSpeed < 0 ) {
        alt_xSpeed += alt_deccel;
        if ( alt_xSpeed > 0 ) {
          alt_xSpeed = 0;
          }
        }
    }
    if (side_flag ==1){
      alt_state = 21;
      if ( alt_xSpeed > 0 ) {
        alt_xSpeed -= alt_deccel;
        if ( alt_xSpeed < 0 ) {
           alt_xSpeed = 0;
        }
      }
      }
    }
     
    if ( up ) {    
      if ( !place_free(x,y+80) && !place_free(x+79,y+80)) {
        alt_ySpeed = -6.3;
      }
    }
    alt_ySpeed += gravity;
    
    xRep = 0; 
    yRep = 0;    
    xRep += floor(abs(alt_xSpeed));
    yRep += floor(abs(alt_ySpeed));
    xSave += abs(alt_xSpeed)-floor(abs(alt_xSpeed));
    ySave += abs(alt_ySpeed)-floor(abs(alt_ySpeed));
    int signX = (alt_xSpeed<0) ? -1 : 1;
    int signY = (alt_ySpeed<0) ? -1 : 1;  
    
    int offsetX = (alt_xSpeed<0) ? 0 : 79;
    int offsetY = (alt_ySpeed<0) ? 0 : 79; 
    
    if ( xSave >= 1 ) {
      xSave -= 1;
      xRep++;
    }
    if ( ySave >= 1 ) {
      ySave -= 1;
      yRep++;
    }
    
    
    for ( ; yRep > 0; yRep-- ) {
      if ( place_free(x,y+offsetY+signY) && place_free(x+79,y+offsetY+signY)) {
        y += signY;
      }
      else {
        alt_ySpeed = 0;
      }
    }
    
    
     for ( ; xRep > 0; xRep-- ) {
      if ( place_free(x+offsetX+signX,y) && place_free(x+offsetX+signX,y+79) ) {
        x += signX;
      }
      else {
        alt_xSpeed = 0;
      }
    }
  }
  
  //------------------------------------------------------------------------------------------------
  void display() {//DISPLAY///////////////
 
    //FRAMES-MOVIMIENTO LEFT
    if (state <0 && state >=-1){
     image(leftA, x, y);
    }
     else if (state <-1 && state >=-2){ 
     image(leftB, x, y);
    }
     else if (state <-2 && state >=-3){
     image(leftC, x, y);
    }
     else if (state <-3 && state >=-4){
     image(leftD, x, y);
    }
     else if (state <-4 && state >=-5){
     image(leftE, x, y);
    }
     else if (state <-5 && state >=-6){
     image(leftF, x, y);
    } 
     else if (state <-6 && state >=-7){
     image(leftG, x, y);
    }
   
     //FRAMES- MOVIMIENTO RIGHT
      else if (state >1 && state <=2){
     image(rightA, x, y);
    }
     else if (state >2 && state <=3){
     image(rightB, x, y);
    }
     else if (state >3 && state <=4){
     image(rightC, x, y);
    }
     else if (state >4 && state <=5){
     image(rightD, x, y);
    }
     else if (state >5 && state <=6){
     image(rightE, x, y);
    }
     else if (state >6 && state <=7){
     image(rightF, x, y);
    }
     else if (state >7 && state <=8){
     image(rightG, x, y);
    }
    
    //STILL
    else if(state==0){
     PImage still;
     still = loadImage("idle2.png");
     image(still, x, y);
    }//END STILL
       else if(state==1){
     PImage still;
     still = loadImage("idle.png");
     image(still, x, y);
    }//END STILL     
  }//END DISPLAY///////////////////
  
  void alt_display() {//DISPLAY///////////////
  
     //FRAMES-MOVIMIENTO LEFT
    if (alt_state <20 && alt_state >=19){
     image(alt_leftA, x, y);
    }
     else if (alt_state <19 && alt_state >=18){ 
     image(alt_leftB, x, y);
    }
     else if (alt_state <18 && alt_state >=17){
     image(alt_leftC, x, y);
    }
     else if (alt_state <17 && alt_state >=16){
     image(alt_leftD, x, y);
    }
     else if (alt_state <16 && alt_state >=15){
     image(alt_leftE, x, y);
    }
     else if (alt_state <15 && alt_state >=14){
     image(alt_leftF, x, y);
    }
     else if (alt_state <14 && alt_state >=13){
     image(alt_leftG, x, y);
    }
    
     //FRAMES- MOVIMIENTO RIGHT
      else if (alt_state >21 && alt_state <=22){
     image(alt_rightA, x,y);
    }
     else if (alt_state >22 && alt_state <=23){
     image(alt_rightB, x, y);
    }
     else if (alt_state >23 && alt_state <=24){
     image(alt_rightC, x, y);
    }
     else if (alt_state >24 && alt_state <=25){
     image(alt_rightD, x, y);
    }
     else if (alt_state >25 && alt_state <=26){
     image(alt_rightE, x, y);
    }
     else if (alt_state >26 && alt_state <=27){
     image(alt_rightF, x, y);
    }
     else if (alt_state >27 && alt_state <=28){
     image(alt_rightG, x, y);
    }
    
    //STILL
    else if(alt_state==20){
     PImage alt_still;
     alt_still = loadImage("left_crouch_1.png");
     image(alt_still, x, y);
    }//END STILL
    
     else if(alt_state==21){
     PImage alt_still;
     alt_still = loadImage("right_crouch_1.png");
     image(alt_still, x, y);
    }//END STILL
      
  }//END DISPLAY///////////////////
}//END CLASS///////////////////////
