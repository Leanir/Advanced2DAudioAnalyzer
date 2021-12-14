class Player{
  int posX, posY;  //posizione del giocatore nella mappa [posX][posY]
  PImage skin;
  
  Player(PImage _skin){
    skin=_skin;
    posX=posY=10;
  }
  
  boolean isHere(int x, int y){
    if(this.posX == x)
      if(this.posY == y)
        return true;
    return false;
  }
}
