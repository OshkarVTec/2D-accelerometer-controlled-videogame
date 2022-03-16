class Mask{
  int x, y;
  PImage mascara;

  
  Mask(int _x, int _y){
    x = _x;
    y = _y;
    mascara = loadImage ("tile132.png");
  }

  void display(){
    image(mascara, x, y);
  }
  
  void change_position(){
     x = int (80 * random(16));
  }

}
