class Onde{
  float speed;
  int intensity;
  color colore;
  
  Onde(float vel, int _intensity){
    speed = vel;
    intensity = _intensity;
  }
  
  void disegna(int posX, int posY, float i){
    ellipseMode(CENTER);
    strokeWeight(5);  noFill();
    
    
    colore=color(255,0,0,intensity);  intensity/=1.1;
    stroke(colore);
    circle(posX+25,posY+25,i);  i+=this.speed;
  }
}
