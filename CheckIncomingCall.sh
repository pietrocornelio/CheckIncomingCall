#!/bin/bash
# ------------------------------------------------------------------
# script bash per eseguire la connessione a un SmartPhone Android
# via ADB USB e leggere i registri per capire chi sta telefonando
# ver. 0.1
# di Pietro Cornelio / 28-08-2015
#
# eseguire lo script in loop ogni 2 secondi col il comando :
# watch -n 2 ./CheckIncomingCall.sh
# ------------------------------------------------------------------
echo "-------------------------------------------------------------"
echo "        Un piccolo script BASH di Pietro Cornelio            "
echo "        rel. 0.1.0 - 28-08-2015                              "
echo "        accesso a smartphone Android 2.3.3 HTC Desider       "
echo "-------------------------------------------------------------"
date1=$(date +"%s")
date
# INSTALLAZIONE TOOLS ANDROID E PHABLET
# sudo add-apt-repository ppa:phablet-team/tools
# sudo apt-get update
# sudo apt-get install ubuntu-device-flash
# sudo apt-get install phablet-tools
#
# per vedere i pacchetti installati
# dpkg -L phablet-tools | grep bin
#
# attivare la comunicazione tra PC e SmartPhone comando:
# adb start-server
# Eseguo la shell remota su SmartPhone:
# adb shell dumpsys telephony.registry | grep Call
#
# estraggo solo il secondo campo delimitato dal simbolo = per ogni riga
# adb shell dumpsys telephony.registry | grep Call| awk -F'=' {'print $2}'

# estraggo dalla riga nr.1 il valore del secondo campo, cioè dopo il simbolo =
# valore numerico 0 o 1 relativo allo stato di presenza chiamata in corso
#
# adb shell dumpsys telephony.registry | grep Call|awk -F'=' 'NR==1{print $2; exit}'
IncomingCall=`adb shell dumpsys telephony.registry | grep Call|awk -F'=' 'NR==1{print $2; exit}' `
#
# per verificare da terminale la presenza di un carattere di controllo eventualmente nascosto
# nella variabile, ho usato il comando : echo $IncomingCall | cat -v
# rimuovo il maledetto carattere ^M dalla variabile...
IncomingCall=$(tr -dc '[[:print:]]' <<< "$IncomingCall")
echo $IncomingCall
#
# per verificare a quale porta USB è collegata la scheda relè usare il comando: dmesg | grep tty
# abilitare/aggiungere l'utente preferito (non root) al gruppo dialout all'uso della porta ttyUSB0 
#
if [ "$IncomingCall" = "0" ]; then
  echo "Nessuna chiamata in corso..."
  # Spengo tutti i relè
  echo -e '\x6E' > /dev/ttyUSB0
else
  echo "Chiamata in corso..."
  # recupero il numero di telefono e lo inserisco nella variabile...
  # adb shell dumpsys telephony.registry | grep Call|awk -F'=' 'NR==2{print $2; exit}'
  NumberCall=`adb shell dumpsys telephony.registry | grep Call|awk -F'=' 'NR==2{print $2; exit}' `
  # rimuovo il carattere di controllo ^M
  NumberCall=$(tr -dc '[[:print:]]' <<< "$NumberCall")
  if [ "$NumberCall" = "+393801122334455" ] 
  then 
    echo "Sta chiamando Pietro..."
    # attivo il relè 1
    echo -e '\x65' > /dev/ttyUSB0
  fi
  # ---------------------------------------------------
  if [ "$NumberCall" = "+39327123456789" ] 
  then 
    echo "Sta chiamando Pippo..."
    # attivo il relè 1
    echo -e '\x65' > /dev/ttyUSB0
  fi
  # ---------------------------------------------------
  if [ "$NumberCall" = "+39339987654321" ] 
  then 
    echo "Sta chiamando Pluto..."
    # attivo il relè 1
    echo -e '\x65' > /dev/ttyUSB0
  fi
  # ---------------------------------------------------
fi

# ------------------------------------
# Setting scheda USB-Seriale a 8 relè
# ------------------------------------
# aggiungere l'utente preferito (non root) al gruppo dialout per abiliatrlo all'uso della porta ttyUSB0
#
# configuro comunicazione seriale del convertitore a 19200 baud
# stty -F /dev/ttyUSB0 19200
#
#
# hex command USB-RLY08
# 64	All relays on
# 65	Turn relay 1 on
# 66	Turn relay 2 on
# 67	Turn relay 3 on
# 68	Turn relay 4 on
# 69	Turn relay 5 on
# 6A	Turn relay 6 on
# 6B	Turn relay 7 on
# 6C	Turn relay 8 on
# 6E	All relays off
# 6F	Turn relay 1 off
# 70	Turn relay 2 off
# 71	Turn relay 3 off
# 72	Turn relay 4 off
# 73	Turn relay 5 off
# 74	Turn relay 6 off
# 75	Turn relay 7 off
# 76	Turn relay 8 off

  
  

