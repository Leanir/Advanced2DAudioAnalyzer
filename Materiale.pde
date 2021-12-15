//La classe Materiale servirà ad istanziare sia oggetti solidi (pareti) che oggetti attraversabili (vuoto, aria, acqua)
//
class Materiale{

  String nome;        //Nome del materiale preso in considerazione
  float velSuono;     //celerità del suono all'interno del materiale, espressa in m/s e divisa per 10 (valori per ora solo a 20 C)
  PImage texture;     //texture delle tiles del materiale
  boolean pass;  //flag che indica che il materiale permette il passaggio al player
  
  //costruttore dell'oggetto Materiale
  Materiale(String _nome, float _vel, PImage _texture, boolean flag){
    nome=_nome;
    velSuono=_vel;
    texture=_texture;
    pass=flag;
  }
  
  //metodi di trasmissione sonorada casella a casella
  void passa(int posXprec, int posYprec, 
             int posX,     int posY,
             int posXsucc, int posYsucc ){
    
  }
  
};
