class Onde{
  int posX, posY;    // Coordinate dell'onda
  float movX, movY; // Fattori di movimento
  int intensity;     // Gestisce l'opacità dell'onda
  float vel;
  float percorsi;
  color colore;      // Colore dell'onda
  
  Onde(int x, int y, float gradi, int _intensity, float velMateriale){
    posX = x;  posY = y;                    // Posizione in pixel sulla mappa iniziali dell'onda
    movX = cos(gradi);  movY = sin(gradi);  // Fattori di movimento dati dall'angolo di partenza dell'onda
    intensity = _intensity;
    vel = velMateriale;
    percorsi=0;
    
    colore = color(255,0,0,intensity);
  }

  
  //PVector intersezione(int ax, int ay, int bx, int by, int cx, int cy, int dx, int dy){
  //  PVector inters;

  //  float uA = ((dx-cx)*(ay-cy) - (dy-cy)*(ax-cx)) / ((dy-cy)*(bx-ax) - (dx-cx)*(by-ay));
  //  float uB = ((bx-ax)*(ay-cy) - (by-ay)*(ax-cx)) / ((dy-cy)*(bx-ax) - (dx-cx)*(by-ay));
    
  //  //// if uA and uB are between 0-1, lines are colliding
  //  //if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

  //    float intersectionX = ax + (uA * (bx-ax));
  //    float intersectionY = ay + (uA * (by-ay));

  //    inters = new PVector(intersectionX,intersectionY);
  //  //}

  //  return inters;
  //}


  //void collisione(PVector inters, ){

  //}

  
  //void disegna(){
    
  //  noStroke();
  //  fill(colore);
  //  ellipse(this.posX, this.posY, 5, 5);

  //  // Va avanti in base all'angolo e alla velocità del materiale su cui si trova (m/100s)
  //  // Tutto ciò seguendo appunto l'angolo, quindi ha una velocità x e una vel y

  //  int spostamentoX = (int)(vel * movX);
  //  int spostamentoY = (int)(vel * movY);

  //  //ora che sappiamo di quanto si sposta, andiamo a mettere sta cosa nel main e ad ogni draw, si sposta di conseguenza

  //  // nel draw verifica che alla prossima iterazione si trovi sullo stesso materiale

  //  int xSucc = posX + spostamentoX;  
  //  int ySucc = posY + spostamentoY;
  //  if(map[xSucc/50][ySucc/50] != map[posX/50][posY/50]){
  //    //avvia la funzione di rimbalzo sul punto che adesso ti dico come trovare, brutto stronzo

  //    if ( xSucc/50 - posX/50 == 1 )  // sappiamo che la casella successiva è a destra
  //      collisione(
  //        intersezione( posX, posY,   xSucc, ySucc,   (xSucc/50)*50, (ySucc/50)*50,   (xSucc/50)*50, (ySucc/50)*50+50 ) );

  //    else if ( xSucc/50 - posX/50 == -1 ) // sappiamo che la casella successiva è a sinistra
  //      collisione(
  //        intersezione(posX, posY,   xSucc, ySucc,   (posX/50)*50, (posY/50)*50,   (posX/50)*50, (posY/50)*50+50)));

  //    else if ( xSucc/50 - posX/50 == 1 ) // sappiamo che la casella successiva è su
  //      collisione(
  //        intersezione(posX, posY,   xSucc, ySucc,   (posX/50)*50, (posY/50)*50,   (posX/50)*50+50, (posY/50)*50)));

  //    else if ( xSucc/50 - posX/50 == -1 ) // sappiamo che la casella successiva è giù
  //      collisione(
  //        intersezione(posX, posY,   xSucc, ySucc,   (xSucc/50)*50, (ySucc/50)*50,   (xSucc/50)*50+50, (ySucc/50)*50)));

  //  }
  //}



}
