/*
  !! Prima di avviare il codice, selezionare la frequenza nella variabile nomeFile alla riga 8 !!
  !! Il nome dei file sono ####Hz.mp3, sostituire #### con uno dei valori: 0125 0250 0500 1000 2000 4000 !!
*/


import processing.sound.*;      // Libreria Sound di Processing
String nomeFile = "0500Hz.mp3"; // Nome del file da riprodurre, da modificare in base alla preferenza        
SoundFile audio;                // Oggetto che andrà ad "immagazzinare" il file audio
SoundFile resultAudio;          // Oggetto che andrà ad "immagazzinare" il file audio recepito dal microfono virtuale 
int indiceAudio;                // In base a nomeFile, ho indice che tiene traccia dell'assorbenza nell'array apposito della classe materiale


boolean provaPartita;           // Indica lo stato della prova, inizialmente false
float SOGLIA = 0.005;           // Serve per far "despawnare" le onde una volta che non le teniamo più in considerazione

ArrayList<Onde> onde;

PFont fontArial;                // servirà per impostare il font del testo su schermo

Materiale selected;             // Oggetto Materiale contenente l'ultimo materiale selezionato dall'utente
Materiale ambiente;             // Oggetto Materiale contentenente il mezzo di trasmissione principale nel quale si trova BOB
boolean selMic;


// ### Dichiarazione degli spazi di memoria utili a setuppare il tutto ###
Materiale[] base = new Materiale[3];        // array contenente i materiali attraversabili
Materiale[] wall = new Materiale[8];        // array contenente i materiali che faranno da pareti
Materiale[][] map = new Materiale[20][20];  // matrice contenente i materiali sulla mappa effettiva
Player BOB;                                 // BOB sarà il nostro monopolo acustico
Microfono mic;                              // Come BOB, mic è un oggetto unico e la prova non potrà partire a meno che questo oggetto non verrà piazzato con click
// ### end ###





void setup(){
  size(1400,1000);                          // Dimensione della finestra fissata a 1400x1000
  frameRate(15);                            // Frame rate della funzione draw
  fontArial = createFont("Arial",18);       // Impostazione font
  
  audio = new SoundFile(this,nomeFile);     // 
  provaPartita=false;
  
  switch(nomeFile){
    case "0125Hz.mp3": indiceAudio = 0; break;
    case "0250Hz.mp3": indiceAudio = 1; break;
    case "0500Hz.mp3": indiceAudio = 2; break;
    case "1000Hz.mp3": indiceAudio = 3; break;
    case "2000Hz.mp3": indiceAudio = 4; break;
    case "4000Hz.mp3": indiceAudio = 5; break;
  }
  
  selMic = false;
  
  // ### riempimento array dei materiali attraversabili da BoB ###
                        //      Nome   m/100s  Immagine associata          flag   125   250   500  1000  2000  4000
  base[0] = new Materiale(    "Vuoto",   0.0, loadImage("void.png"),       true, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00 );
  base[1] = new Materiale(     "Aria",  3.43, loadImage("tile.png"),       true, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00 );
  base[2] = new Materiale(     "Mare", 14.60, loadImage("wateryTile.png"), true, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00 );
  // ### end ###
  
  
  // ### riempimento array dei materiali che fungono da pareti od ostacoli per BoB ###
                        //          Nome   m/100s  Immagine associata         flag    125   250   500  1000  2000  4000
  wall[0] = new Materiale(         "Marmo", 38.00, loadImage("marble.png"),   false, 0.01, 0.01, 0.02, 0.02, 0.02, 0.03 );
  wall[1] = new Materiale(       "Mattoni", 36.50, loadImage("bricks.png"),   false, 0.02, 0.02, 0.03, 0.04, 0.05, 0.07 );
  wall[2] = new Materiale(         "Vetro", 50.00, loadImage("glass.png"),    false, 0.03, 0.03, 0.03, 0.03, 0.02, 0.02 );
  wall[3] = new Materiale( "C. Intonacato", 57.90, loadImage("intonaco.png"), false, 0.01, 0.01, 0.01, 0.02, 0.02, 0.03 );
  wall[4] = new Materiale(       "Cemento", 57.90, loadImage("cement.png"),   false, 0.36, 0.44, 0.31, 0.29, 0.39, 0.25 );
  wall[5] = new Materiale(    "Legno Pino", 39.60, loadImage("pinewood.png"), false, 0.10, 0.10, 0.10, 0.09, 0.10, 0.12 );
  wall[6] = new Materiale(   "Lana Roccia",  1.80, loadImage("rockwool.png"), false, 0.26, 0.45, 0.61, 0.72, 0.75, 0.85 );
  wall[7] = new Materiale(        "Sabbia", 16.26, loadImage("sand.png"),     false, 0.24, 0.34, 0.45, 0.62, 0.76, 0.95 );
  // ### end ###
  
  
  // ### inizializzazione mappa ###
  ambiente = base[0];        //materalie iniziale = vuoto
  
  for(int i=0;i<20;i++) 
    for(int j=0;j<20;j++) 
      map[i][j] = ambiente;  //la mappa comincia come vuota
  // ### end ###
  
  // ecco la nostra star
  BOB = new Player(loadImage("BOB1.png"));
  
  // e chi lo ascolta
  mic = new Microfono();

  onde = new ArrayList<Onde>();
  
}




void draw(){
  
  // ### Disegna la mappa ###
  for(int i=0; i<20; i++)
    for(int j=0; j<20; j++)
      image(map[i][j].texture,50*i,50*j);
  // ### end ###
  
  image(BOB.skin,BOB.posX*50,BOB.posY*50);       //questo fa vedere BOB in mappa. Ciao BOB
  if(mic.placed) 
    image(mic.texture,mic.posX*50,mic.posY*50);  // e questo fa vedere il microfono se piazzato. Ciao microfono
  
  // ### Disegna le barre utilità ###
  fill(235); noStroke();  rect(1000,0,400,1000); //creiamo la base colore sopra la quale stanno le barre utilità
  fill(0);  textFont(fontArial);                 //imposta il font
  
  text("Base", 1105, 75);                        //stampa "Base" sopra la lista interagibile
  for(int i=0;i<base.length;i++){
    text(base[i].nome, 1050, 125+i*50);          //stampa il nome della base a sinistra della lista
    image(base[i].texture, 1100, 100+i*50);      //stampa le texture in una lista interagibile
  }
  
  text("Mic", 1050, 325);
  image(mic.texture, 1100, 300);
  
  text("Mura", 1205, 75);                        //stampa "Mura" sopra la lista interagibile
  for(int i=0;i<wall.length;i++){
    text(wall[i].nome, 1260, 125+i*50);          //stampa il nome della parete a destra della lista
    image(wall[i].texture, 1200, 100+i*50);      //stampa le texture delle pareti in una lista interattiva
  }
  
  if(!provaPartita){
    text("Avvia", 1050, 575);
    image(loadImage("play.png"), 1100, 550);    //icona della cancellazione parete
  }else{
    text("Stop", 1050, 575);
    image(loadImage("stop.png"), 1100, 550);     //icona della cancellazione parete
  }
  
  text("Cancella", 1260, 575);
  image(loadImage("gomma.png"), 1200, 550);  //icona della cancellazione parete
  // ### Fine della sezione barre utilità ###
  
  
  
  text("Frequenza: ", 1050, 800);  text(nomeFile, 1200, 800);
  text("Riverbero: ", 1050, 820);  text(int(map[mic.posX][mic.posY].reverb), 1200, 820);
  text("Echo: "     , 1050, 840);  text(int(map[mic.posX][mic.posY].echo), 1200, 840);
  text("Intensità: ", 1050, 860);  text(map[mic.posX][mic.posY].intensity, 1200, 860);
  
  if(onde.size() != 0){
    
    int i = 0;
    
    while(i < onde.size()){
      onde.get(i).disegna(onde);
      i++;
    }
    
  }
  
}




// ### Comandi movimento BOB ###
// ### Usa le frecce direzionali per spostare BOB ###
// ### N.B.: BOB non può uscire dalla mappa ###
void keyPressed(){
  if(!provaPartita){
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
}





// ### Definizione comandi Click ###
void mousePressed(){
  
  // se fai click su AVVIA/STOP, cambia l'icona e lo stato della prova
  if(mouseX > 1100 && mouseX < 1150){
    if(mouseY > 550 && mouseY < 600){
      if(mic.placed){
        provaPartita = !provaPartita;
        if(provaPartita){
          audio.play();
          
          for(int i = 0; i<45; i++){
            onde.add(new Onde(BOB.posX, BOB.posY, cos(radians(8.0*i)), sin(radians(8.0*i)), 255, map[BOB.posX][BOB.posY].velSuono));
          }
          
          getStarted(BOB.posX, BOB.posY);
        } 
        else audio.stop();
      }
      else print("Microfono non ancora piazzato, non posso partire");
    }
  }
  
  
  if(!provaPartita){
    //se fai click sulla zona mezzi di trasmissione principale, cambia tutte le caselle senza pareti in caselle di quel materiale
    if(mouseX>=1100 && mouseX<=1150){
      switch((mouseY-100)/50){
        case 0: ambiente = base[0]; break;
        case 1: ambiente = base[1]; break;
        case 2: ambiente = base[2]; break;
        
        // per efficienza di codice, includiamo qui anche la selezionde del microfono
        case 4: selMic = true; break;
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
        case 6: selected = wall[6]; break;
        case 7: selected = wall[7]; break;
      }
      if(mouseY>=550 && mouseY<=600){
        selected = ambiente;
      }
    }
    
    //se fai click sulla mappa, cambia il materiale di quella casella col materiale selezionato
    else if(mouseX >= 0 && mouseX <= 1000 && selected != null){
      if(!BOB.isHere(mouseX/50, mouseY/50) && !mic.isHere(mouseX/50, mouseY/50))
        if(selMic && map[mouseX/50][mouseY/50] == ambiente){
          mic.set(mouseX/50,mouseY/50);
          selMic = false;
        }
        else 
          map[mouseX/50][mouseY/50] = selected;
    }
    
  }
  
}












//parte del sistema calcolo audio

void controlloProgressivo(int x, int y, int attuale){          //passiamo laposizione (x,y) e il progressivo attuale
  int control = map[x][y].prog_iniziale;                       //salvo il valore iniziale del progressivo (default 0) nella variabile di controllo                     
           
  
  if (control==0)                                              //correggo i valori dei progressivi in base ai loro valori
    map[x][y].prog_iniziale = map[x][y].progressivo = attuale;
  else if ( map[x][y].progressivo < attuale ) 
    map[x][y].progressivo = attuale;                           //aggiorno il progressivo solo se il nuovo è maggiore
  
  if ( map[x][y].prog_iniziale > attuale )  
    map[x][y].prog_iniziale = attuale;                         //aggiorno il progressivo iniziale se ne trovo uno minore


  if( attuale-control > 33 && ambiente == base[1] )            //verifico se si svolge l'eco ed eventualmente aggiorno materiale
    map[x][y].echo = true;
}


boolean controlloRiflessione(int x, int y, int incO, int incV){          
  if(map[x][y].nome!=map[x+incO][y+incV].nome) return true;
  return false;
}


boolean Dispersione(int x, int y){                                
  if( map[x][y].intensity<SOGLIA ) 
    return true;
  return false;
}

boolean fuoriLimiti(int x, int y){
  if(x<=0 || x>=19 || y<=0 || y>=19)
    return true;
  return false;
}


void Diffusione(int x, int y, int incO, int incV, float intens, int progressivo){
  
  if(fuoriLimiti(x,y)){
    return;
  }else{
    map[x][y].intensity = (intens / pow(progressivo, 2));  // modifico l'intensità con la legge dell'inverso del quadrato
    //println( x, " ", y, " ", map[x][y].intensity );
  }
  
  if (Dispersione( x, y ))  return;               // Nel caso in cui la dispersione dà esito positivo, non richiama più nulla

  controlloProgressivo(x, y, progressivo);        // controllo eco e aggiornamento progressivi di Materiale


  if( incO == 0 || incV == 0){                                             // Se uno dei due incrementi è 0, siamo nel caso orizzontale o vertcale
    //println(intens*(map[x+incO][y+incV].assorbenza[indiceAudio]));
    Diffusione(x+incO, y+incV, incO, incV, intens*(map[x+incO][y+incV].assorbenza[indiceAudio]), progressivo+1);           
    if(controlloRiflessione(x, y, incO, incV))                                        //se include la riflessione
      Diffusione(x-incO, y-incV, -incO, -incV, intens*(1.0-map[x][y].assorbenza[indiceAudio]), progressivo+1);        

  }else{                                                                              //caso Obliquo
  
    Diffusione(x, y+incV, 0, incV, intens*(map[x][y].assorbenza[indiceAudio]), progressivo+1);                     //diramazione verticale
    Diffusione(x+incO, y, incO, 0, intens*(map[x][y].assorbenza[indiceAudio]), progressivo+1);                     //diramazione orizzontale
    Diffusione(x+incO, y+incV, incO, incV, intens*(map[x][y].assorbenza[indiceAudio]), progressivo+1);             //diramazione obliqua
    
    if(controlloRiflessione(x, y, 0, incV))                                           //verifica riflessione nel ramo verticale
      Diffusione(x, y-incV, 0, -incV, intens*(1.0-map[x][y].assorbenza[indiceAudio]), progressivo+1); 
    if(controlloRiflessione(x, y, incO, 0))                                           //verifica riflessione nel ramo orizzontale
      Diffusione(x-incO, y, -incO, 0, intens*(1.0-map[x][y].assorbenza[indiceAudio]), progressivo+1);
    if(controlloRiflessione(x, y, incO, incV)){                                       //verifica riflessione nel ramo obliquo, split dell'onda in due
      Diffusione(x-incO, y+incV, -incO, +incO, intens*(1.0-map[x][y].assorbenza[indiceAudio]), progressivo+1);
      Diffusione(x+incO, y-incV, +incO, -incO, intens*(1.0-map[x][y].assorbenza[indiceAudio]), progressivo+1);
    }
  }
}


void getStarted(int posX, int posY){                                                  //viene richiamata quando l'utente clicca AVVIA
  int x = posX;
  int y = posY;
  for(int i=-1; i<2; i++)
    for(int j=-1; j<2; j++){
      delay(500);
      if( !(i==0 && j==0) ){
        Diffusione( x+i, y+j, i, j, 100.0, 1);                            //vengono avviate le otto diramazioni di diffusione
        //println("I dati per la casella ", x+i, " ", y+j, "sono ", map[x+i][y+j].intensity);
      }
    }
}
