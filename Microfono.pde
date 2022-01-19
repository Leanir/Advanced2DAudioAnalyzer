class Microfono{
  int posX, posY;
  boolean placed;
  PImage texture;
  
  Microfono(){
    placed=false;
    texture = loadImage("mic.png");
  }
  
  void set(int x, int y){
    posX=x;
    posY=y;
    placed=true;
  }
  
  boolean isHere(int x, int y){
    if(x==posX && y==posY) 
      return true;
    return false;
  }
  
}
