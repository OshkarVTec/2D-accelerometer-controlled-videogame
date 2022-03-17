import processing.sound.*;
import processing.serial.*;

PImage bgd;
PImage start;
PFont Monserrat;
int ratio = 80;

final int WIDTH = 16;
final int HEIGHT = 8;
int[][] level = new int[HEIGHT][WIDTH];

Serial port;
Player p1;
Mask b1;
int r = int(random(16));
char inByte;
SoundFile bgd_sound;
 
boolean right = false, left = false, up = false;
String soundName = "hollow_knight_OST.mp3";
boolean transform = false;
String path = "";
int counter = -1;
boolean t_flag = true;
 
 //SETUP/////////////////////////////
void setup() {
  size(1280,640);
  port = new Serial(this, "COM6", 115200);
  p1 = new Player(WIDTH*10,HEIGHT*10, width);
  b1 = new Mask (r* 80, 0);
  path = sketchPath (soundName);
  bgd_sound = new SoundFile(this, path);
  bgd_sound.play();
  counter = -1;
  bgd = loadImage ("City_of_Tears.jpg");
  start = loadImage("title.jpg");
}
void draw() {
  if (counter == -1){
    //Start screen 
    background(255);
    image(start,140, 100 );
    fill(0);
    textSize(30);
    text("By:", 620, 500);
    text("Diego Garcia Rueda", 220, 550);
    text("Oskar Adolfo Villa López", 750, 550);
    text("Presione ENTER para iniciar", 450, 600);
  }
  else if (counter > 2){
   //Ending screen/ GAME OVER screen
   port.write(str(counter));
   fill(0);
   background(255); 
   textSize(60);
   text("Thanks for Playing!", 380, 320);
   
  }
  else{
  background (bgd);
  b1.display();
   if (0 < port.available()) { 
    port.write(str(counter));
    inByte = port.readChar();
    if (inByte != 't'){t_flag = false;}
    
   // println(inByte);
  } 
  if (inByte == 'a'){println('a');right=false; left = true; t_flag = false;}
  if (inByte == 'd'){println('d');right=true; left = false; t_flag = false;}
  if (inByte == 'w'){println('w');right=false; left = false; t_flag = false;} 
  if (inByte == 't' && !t_flag ){ 
  t_flag = true;  
  if (transform == true){
    transform = false;}
  else{
    transform = true;
  }
  }
  
  if (!transform){
    p1.update();
    p1.display();
    level_Creation();
    //p1.show();
    if ((abs(p1.x - b1.x) < 79) && (abs(p1.y - b1.y) < 79)){
    counter++;
    level_Restart();
    transform = false;
    }
  }
  else{
    p1.alt_update();
    p1.alt_display(); 
    level_Creation();
    //p1.show();
     if ((abs(p1.x - b1.x) < 79) && (abs(p1.y - b1.y) < 79)){
    counter++;
    level_Restart();
    }
   }
  }
}

 
 void level_Creation(){
  fill(0);
  noStroke();
  for ( int ix = 0; ix < WIDTH; ix++ ) {
    for ( int iy = 0; iy < HEIGHT; iy++ ) {
      switch(level[iy][ix]) {
        case 1: 
          fill(color(52,73,94));
          rect(ix*80,iy*80,80,80);
      }
    }
  }
 }
 
 boolean place_free(int xx,int yy) {
   xx = int(floor(xx/80.0));
   yy = int(floor(yy/80.0));
   
   if ( xx > -1 && xx < level[0].length && yy > -1 && yy < level.length ) {
    if ( level[yy][xx] == 0 ) {
      return true;
    }
  }
   return false;
}  

void level_Restart(){
    for ( int ix = 0; ix < WIDTH; ix++ ) {
    for ( int iy = 0; iy < HEIGHT; iy++ ) {
      level[iy][ix] = 0; 
      }
    }
    b1.change_position();
  }


void keyPressed() {
  switch(key) {
    case 'd': right = true; break;
    case 'a': left = true; break;
    case 32: up = true; break;
    case 't': 
      if (transform == true ){
        transform = false;
      }
      else if(transform == false){
        transform = true;
      }
      break;  
   case ENTER: 
     if (counter == -1){
       counter++;
     }break;
  }    
}
void keyReleased() {
  switch(key) {
    case 'd': right = false; break;
    case 'a': left = false; break;
    case 32: up = false; break;
  }
}

void mousePressed() {
//Left click creates/destroys a block
  if ( mouseButton == LEFT ) {
    level[int(floor(mouseY/80.0))][int(floor(mouseX/80.0))] ^= 1;
  }
}
