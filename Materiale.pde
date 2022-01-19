//La classe Materiale servirà ad istanziare sia oggetti solidi (pareti) che oggetti attraversabili (vuoto, aria, acqua)
//
class Materiale{

  String nome;           // Nome del materiale preso in considerazione
  float velSuono;        // Celerità del suono all'interno del materiale, espressa in m/s e divisa per 10 (valori per ora solo a 20 C)
  PImage texture;        // Texture delle tiles del materiale
  boolean pass;          // Flag che indica che il materiale permette il passaggio al player
  float intensity;       // Intensità dell'audio passante per questo materiale, la sua applicazione principale risiede nel main
  int progressivo;       // Intero di supporto per il calcolo della distanza di propagazione 
  int prog_iniziale;     // Come sopra, ma stadio iniziale del materiale
  boolean reverb;        // Valore booleano che indica se nel materiale, durante il calcolo, è presente il riverbero
  boolean echo;          // Valore booleano che indica se nel materiale, durante il calcolo, è presente l'eco
  float [] assorbenza;   // !!
  
  //costruttore dell'oggetto Materiale
  Materiale(String _nome, float _vel, PImage _texture, boolean flag, float Hz125, float Hz250, float Hz500, float Hz1000, float Hz2000, float Hz4000){
    nome = _nome;
    velSuono = _vel;
    texture = _texture;
    pass = flag;
    intensity = 0.0;
    progressivo = 0;
    reverb = false;
    echo = false;
    
    assorbenza = new float[6];
    assorbenza[0] = Hz125;
    assorbenza[1] = Hz250;
    assorbenza[2] = Hz500;
    assorbenza[3] = Hz1000;
    assorbenza[4] = Hz2000;
    assorbenza[5] = Hz4000;
  }
  
};
