//La classe Materiale servirà ad istanziare sia oggetti solidi (pareti) che oggetti attraversabili (vuoto, aria, acqua)
//
class Materiale{

  String nome;           // Nome del materiale preso in considerazione
  float velSuono;        // Celerità del suono all'interno del materiale, espressa in m/s e divisa per 10 (valori per ora solo a 20 C)
  PImage texture;        // Texture delle tiles del materiale
  boolean pass;          // Flag che indica che il materiale permette il passaggio al player
  float intensity;       // intensità dell'audio passante per questo materiale, la sua applicazione principale risiede nel main
  int progressivo;       // intero di supporto per il calcolo della distanza di propagazione 
  int prog_iniziale;     // come sopra, ma stadio iniziale del materiale
  boolean echo;          // valore booleano che indica se nel materiale, durante il calcolo, è presente l'eco
  float [] assorbenza;   // !!
  
  //costruttore dell'oggetto Materiale
  Materiale(String _nome, float _vel, PImage _texture, boolean flag){
    nome=_nome;
    velSuono=_vel;
    texture=_texture;
    pass=flag;
    intensity=0.0;
    progressivo=0;
    echo=false;
  }
  
};
