# Advanced2DAudioAnalyzer
Progetto 0B dell'a.a. 21/22

In breve:

Il progetto consiste nella realizzazione di un ambiente 2D personalizzabile dall'utente utilizzando Processing 3.
Successivamente alla creazione e al posizionamento dei due token fondamentali (il monopolo acustico e il microfono virtuale), sarà possibile avviare il test per capire come il suono si trasmette all'interno dell'ambiente creato e come arriva al microfono virtuale.

V1 docuentazione progetto: https://fmilotta.github.io/teaching/audioprocessing21/Projects/AudioProcessing-Project-0Bb-2021-IT.pdf

## Bug minori noti:

- Prima di poter selezionare e piazzare il microfono, deve essere stata selezionata una parete
- La propagazione grafica delle onde non è "circolare", possibile difetto di conversioni da float o int e viceversa
- In alcuni casi del calcolo audio, se dei valori scendono sotto la SOGLIA (vedi codice per maggiori informazioni), si genera un loop apparentemente infinito, tuttavia non dannoso ai fini dell'output del microfono virtuale

## Bug maggiori noti:

- La propagazione grafica delle onde è corretta, ma non rimbalzano nè vengono assorbite dalle pareti
- L'intensità audio in caselle non verticali o orizzontali rispetto a quella di propagazione risulta anomala
