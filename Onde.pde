class Onde{
   
  int posX, posY; // Coordinate dell'onda
  float movX, movY; // Fattori di movimento
  int intensity; // Gestisce l'opacità dell'onda
  float vel; // La velocità del materiale su cui si trova
  float percorsi; // Indica quanti pixel sono stati percorsi dall'onda
  color colore; // Colore dell'onda
   
   
  // Mel main creo le prime onde con Onde(BOB.posX, BOB.posY, cos(radians(8*i)), sen(radians(8*i)), 255, map[BOB.posX][BOB.posY].vel)
  Onde(int x, int y, float _movX, float _movY, int _intensity, float velMateriale){
    posX = x*50+25; posY = y*50+25; // Posizione in pixel sulla mappa iniziali dell'onda
    movX = _movX; movY = _movY; // Fattori di movimento dati dall'angolo di partenza dell'onda
    intensity = _intensity;
    vel = velMateriale;
    percorsi = 0.0;
     
    colore = color(255,0,0,intensity);
  }
 
   
  void disegna(ArrayList<Onde> waves){
    noStroke();
    fill(this.colore);
    ellipse(this.posX, this.posY, 9, 9);
 
    
 
    int xSucc = (int)(posX + vel * movX);
    int ySucc = (int)(posY + vel * movY);
    
    if(xSucc<0 || xSucc>1000 || ySucc<0 || ySucc>1000){
      waves.remove(this);
    }else if( map[this.posX/50][this.posY/50] != map[xSucc/50][ySucc/50] ){
 
      if ( xSucc/50 - posX/50 == 1 ) // sappiamo che la casella successiva è a destra
        impatto( intersezione( this.posX, this.posY, xSucc, ySucc, (xSucc/50)*50, (ySucc/50)*50, (xSucc/50)*50, (ySucc/50)*50+50 ),
                 waves, 1, -1 );
 
      else if ( xSucc/50 - posX/50 == -1 ) // sappiamo che la casella successiva è a sinistra
        impatto( intersezione(posX, posY, xSucc, ySucc, (posX/50)*50, (posY/50)*50, (posX/50)*50, (posY/50)*50+50),
                 waves, 1, -1 );
 
      else if ( xSucc/50 - posX/50 == 1 ) // sappiamo che la casella successiva è su
        impatto( intersezione(posX, posY, xSucc, ySucc, (posX/50)*50, (posY/50)*50, (posX/50)*50+50, (posY/50)*50),
                 waves, -1, 1 );
 
      else if ( xSucc/50 - posX/50 == -1 ) // sappiamo che la casella successiva è giù
        impatto( intersezione(posX, posY, xSucc, ySucc, (xSucc/50)*50, (ySucc/50)*50, (xSucc/50)*50+50, (ySucc/50)*50),
                 waves, -1, 1 );
 
    }else{
 
      this.posX = xSucc;
      this.posY = ySucc;
      this.percorsi += this.vel;
 
      this.intensity = (int)(255 * (map[this.posX/50][this.posY/50].velSuono / (percorsi/50)));
 
      if(this.intensity < 10.0)
        waves.remove(this);
      else
        this.colore = color(255, 0, 0, this.intensity);
 
    }
  }
 
 
 
  PVector intersezione(int ax, int ay, int bx, int by, int cx, int cy, int dx, int dy){
    PVector inters;
    int intersectionX;
    int intersectionY;
 
 
    if(ax == bx){
      intersectionX = ax;
      intersectionY = cy;
    }else if(ay == by){
      intersectionY = ay;
      intersectionX = cx;
    }else if(cx == dx){
      intersectionX = cx;
      intersectionY = ( ((intersectionX-ax) * (by-ay)) / (bx-ax) ) + ay;
    }else if(cy == dy){
      intersectionY = cy;
      intersectionX = ( ((intersectionY-ay) * (bx-ax)) / (by-ay) ) + ax;
    }else{
      float mAB = (by-ay)/(bx-ax);
      float mCD = (dy-cy)/(dx-cx);
      float qAB = (bx*ay - ax*by)/bx-ax;
      float qCD = (dx*cy - cx*dy)/dx-cx;
 
      intersectionX = (int)((qCD-qAB)/(mAB-mCD));
      intersectionY = ( ((intersectionX-ax) * (by-ay)) / (bx-ax) ) + ay;
    }
 
 
    inters = new PVector(intersectionX,intersectionY);
    return inters;
  }
 
 
 
  void impatto(PVector puntoImpatto, ArrayList<Onde> waves, int updown, int leftright){
    //waves.add(new Onde((int)puntoImpatto.x, (int)puntoImpatto.y,
    //                   this.movX, this.movY,
    //                   (int)(this.intensity*map[(int)puntoImpatto.x/50][(int)puntoImpatto.y/50].assorbenza[indiceAudio]),
    //                   map[(int)puntoImpatto.x/50][(int)puntoImpatto.y/50].velSuono)); //onda che prosegue nel prossimo materiale
    this.setIntensity();
    waves.add(new Onde((int)puntoImpatto.x, (int)puntoImpatto.y,
                       this.movX*updown, this.movY*leftright,
                       (int)(this.intensity*(1.0-map[(int)puntoImpatto.x/50][(int)puntoImpatto.y/50].assorbenza[indiceAudio])),
                       this.vel));
    waves.remove(this);
  }
   
   
  void setIntensity(){
    this.intensity *= map[this.posX/50][this.posX/50].assorbenza[indiceAudio];
  }
  
}
