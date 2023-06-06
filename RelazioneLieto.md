# Relazione progetto SOAR

Andrea Cacioli
Matricola: 914501

## Escape Game

In questo progetto é stato necessario utilizzare l'architettura cognitiva **SOAR** per modellare il comportamento di un agente rinchiuso in una stanza con l'obiettivo di scappare attraverso una finestra. Tale gente ha a disposizione  diversi oggetti di cui però all'inizio non so il funzionamento, tuttavia attraverso un meccanismo di **Reinforcement Learning** l'agente imparerá a fare le giuste combinazioni di oggetti al fine di creare una fionda, rompere la finestra e scappare.

## Modellazione della conoscenza

Le assunzioni che sono state fatte (per non rendere troppo complicato il progetto modellando anche la fisica del mondo) sono le seguenti:

- Il robot puó in ogni momento trovarsi in una di quattro posizioni: nord, sud, est, ovest.
- Il robot sa fin da subito dove si trova la finestra e dove si trovano i tronchi. (Si puó immaginare che la stanza sia sufficientemente piccola da avere tutto a vista)