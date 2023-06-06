# Relazione progetto SOAR

Andrea Cacioli
Matricola: 914501

## Escape Game

In questo progetto é stato necessario utilizzare l'architettura cognitiva **SOAR** per modellare il comportamento di un agente rinchiuso in una stanza con l'obiettivo di scappare attraverso una finestra. Tale gente ha a disposizione  diversi oggetti di cui però all'inizio non so il funzionamento, tuttavia attraverso un meccanismo di **Reinforcement Learning** l'agente imparerá a fare le giuste combinazioni di oggetti al fine di creare una fionda, rompere la finestra e scappare.

## Modellazione della conoscenza

Le assunzioni che sono state fatte (per non rendere troppo complicato il progetto modellando anche la fisica del mondo) sono le seguenti:

- Il robot puó in ogni momento trovarsi in una di quattro posizioni: **nord, sud, est, ovest**.
- Il robot sa fin da subito dove si trova la **finestra** e dove si trovano i **tronchi**. (Si puó immaginare che la stanza sia sufficientemente piccola da avere tutto a vista).
- Il robot sa che puó **combinare** gli elementi che trova (molla, rametto, sassolini).
- Il robot sa che puó sparare alla finestra in due modi diversi: 
  - Ai bordi
  - Al centro
- Il robot **non** sa né quale sia la migliore combinazione di oggetti che gli permetterá di avere una fionda, né quale sia il punto giusto da sparare quando si spara alla finestra.
- Il robot sa qual é il movimento migliore da fare nelle varie situazioni.

## Risoluzione Impasse

L'impasse é risolta in modi diversi a seconda di cosa sta succedendo intorno al robot.

### Impasse per il movimento

- L'operatore che ti muove verso i tronchi é sempre il migliore quando si hanno i tronchi.
- L'operatore che ti muove verso la finestra é sempre il migliore quando si hanno i tronchi ma la finestra non é ancora rotta.

### Impasse per la combinazione di oggetti

Qui la scelta dell'operatore all'inizio é casuale (numeric indifferent) dopodiché la scelta é presa grazie al reinforcement learning.

### Impasse per lo sparo alla finestra

Qui la scelta dell'operatore all'inizio é casuale (numeric indifferent) dopodiché la scelta é presa grazie al reinforcement learning.

## 