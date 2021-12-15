import processing.sound.*;
AudioIn in;

Onde daBOB;
int velCerchio;


PFont fontArial;          //servirà per impostare il font ad Arial 18
Materiale selected;
Materiale ambiente;

// ### Dichiarazione degli spazi di memoria utili a setuppare il tutto ###
Materiale[] base = new Materiale[3];        // array contenente i materiali attraversabili
Materiale[] wall = new Materiale[6];         // array contenente i materiali ostacolo
Materiale[][] map = new Materiale[20][20];   // matrice contenente le tiles che frmano la mappa effettiva
Player BOB;                                  // oggetto controllato dall'utente
// ### end ###




void setup(){
  size(1400,1000);                      //dimensione della finestra fissata
  frameRate(15);                        //frame rate della funzione draw
  fontArial = createFont("Arial",18);   //impostazione font
  in = new AudioIn(this);               //prende il microfono in input
  //in.play();
  
  
  // ### riempimento array dei materiali attraversabili da BoB ###
                        //      Nome   m/10s  Immagine associata           flag
  base[0] = new Materiale(    "Vuoto",   0.0, loadImage("tile.png"),       true );
  base[1] = new Materiale(     "Aria",  34.3, loadImage("tile.png"),       true ); 
  base[2] = new Materiale(     "Mare", 146.0, loadImage("wateryTile.png"), true );
  // ### end ###
  
  
  // ### riempimento array dei materiali che fungono da pareti od ostacoli per BoB ###
                        //          Nome   m/10s  Immagine associata          flag
  wall[0] = new Materiale(        "Marmo", 380.0, loadImage("marble.png"),    false );
  wall[1] = new Materiale(      "Mattoni", 365.0, loadImage("bricks.png"),    false );
  wall[2] = new Materiale(        "Vetro", 500.0, loadImage("glass.png"),     false );
  wall[3] = new Materiale(      "Acciaio", 579.0, loadImage("steel.png"),     false );
  //wall[4] = new Materiale(  "PVC Rigido",   8.0, loadImage("PVCm.png"),       false );
  wall[4] = new Materiale(     "Intonaco", 579.0, loadImage("intonaco.png"),  false );
  wall[5] = new Materiale(      "Cemento", 579.0, loadImage("cement.png"),    false );
  // ### end ###
  
  
  // ### inizializzazione mappa ###
  ambiente = base[0];                                                //materalie iniziale = vuoto
  
  for(int i=0;i<20;i++) for(int j=0;j<20;j++) map[i][j] = ambiente;  //la mappa comincia come vuota
  // ### end ###
  
  
  BOB = new Player(loadImage("BOB1.png"));    // ### ecco la nostra star ###
  
  daBOB=new Onde(34.3,255);
}




void draw(){
  // ### Disegna la mappa ###
  for(int i=0; i<20; i++)
    for(int j=0; j<20; j++)
      image(map[i][j].texture,50*i,50*j);
  // ### end ###
  
  image(BOB.skin,BOB.posX*50,BOB.posY*50);    //questo fa vedere BOB in mappa. Ciao BOB
  
  
  // ### Disegna le barre utilità ###
  fill(235); noStroke();  rect(1000,0,400,1000);         //creiamo la base colore sopra la quale stanno le barre utilità
  fill(0);  textFont(fontArial);             //imposta il font
  
  text("Base", 1105, 75);                    //stampa "Base" sopra la lista interagibile
  for(int i=0;i<base.length;i++){
    text(base[i].nome, 1050, 125+i*50);      //stampa il nome della base a sinistra della lista
    image(base[i].texture, 1100, 100+i*50);  //stampa le texture in una lista interagibile
  }
  
  text("Mura", 1205, 75);                    //stampa "Mura" sopra la lista interagibile
  for(int i=0;i<wall.length;i++){
    text(wall[i].nome, 1260, 125+i*50);      //stampa il nome della parete a destra della lista
    image(wall[i].texture, 1200, 100+i*50);  //stampa le texture delle pareti in una lista interagibile
  }
  
  text("Gomma Infame", 1260, 525);
  image(loadImage("gomma.png"), 1200, 500);  //icona della cancellazione parete
  // ### end ###
  
  daBOB.disegna(BOB.posX*50, BOB.posY*50, velCerchio+=daBOB.speed);
  
}

void keyPressed(){
  if(keyCode == UP){
    if(BOB.posY>0 && map[BOB.posX][BOB.posY-1].pass==true)
      BOB.posY--;
  }
  
  if(keyCode == DOWN){
    if(BOB.posY<19 && map[BOB.posX][BOB.posY+1].pass==true)
      BOB.posY++;
  }
  
  if(keyCode == LEFT){
    if(BOB.posX>0 && map[BOB.posX-1][BOB.posY].pass==true)
      BOB.posX--;
  }
  
  if(keyCode == RIGHT){
    if(BOB.posX<19 && map[BOB.posX+1][BOB.posY].pass==true)
      BOB.posX++;
  }
  
}

void mousePressed(){
  //se fai click sulla zona mezzi di trasmissione principale, cambia tutte le caselle senza pareti in caselle di quel materiale
  if(mouseX>=1100 && mouseX<=1150){
    switch((mouseY-100)/50){
      case 0: ambiente = base[0]; break;
      case 1: ambiente = base[1]; break;
      case 2: ambiente = base[2]; break;
    }
    
    for(int k=0;k<20;k++){
      for(int l=0;l<20;l++){
        if(map[k][l]==base[0] || map[k][l]==base[1] || map[k][l]==base[2])
          map[k][l]=ambiente;
      }
    }
  }
  
  //se fai click sulla zona materiali delle pareti, seleziona il materiale corrispondente
  else if(mouseX>=1200 && mouseX<=1250){
    switch((mouseY-100)/50){
      case 0: selected = wall[0]; break;
      case 1: selected = wall[1]; break;
      case 2: selected = wall[2]; break;
      case 3: selected = wall[3]; break;
      case 4: selected = wall[4]; break;
      case 5: selected = wall[5]; break;
    }
    if(mouseY>=500 && mouseY<=550){
      selected = ambiente;
    }
  }
  

  
  //se fai click sulla mappa, cambia il materiale di quella casella col materiale selezionato
  else if(mouseX>=0 && mouseX<=1000 && selected != null){
    if(!BOB.isHere(mouseX/50, mouseY/50))
      map[mouseX/50][mouseY/50] = selected;
  }
  
}
