class Player{
  int posX, posY;  // Posizione del giocatore nella mappa [posX][posY]
  PImage skin;     // Immagine che rappresenta BOB
  
  Player(PImage _skin){
    skin=_skin;
    posX=posY=10;
  }
  
  // Metodo che indica se BOB si trova in un certo punto sulla mappa
  boolean isHere(int x, int y){
    if(this.posX == x)
      if(this.posY == y)
        return true;
    return false;
  }
}
