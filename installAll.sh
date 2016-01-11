#!/bin/bash

[ $UID -ne 0 ] && echo "bist nicht root! Programm ende" && exit 0

W='\u2500';     dW='\u2501';     xW='\u2501'    # waage rechte             
S='\u2502';     dS='\u2503';     xS='\u2503'    # senk rechte
eUR='\u2518';   deUR='\u251B';   xeUR='\u251B'  # ecke unten rechts
eUL='\u2514';   deUL='\u2517';   xeUL='\u2517'  # ecke unten lings   
eOR='\u2510';   deOR='\u2513';   xeOR='\u2513'  # ecke oben rechts
eOL='\u250F';   deOL='\u250F';   xeOL='\u250F'  # ecko oben links
tOM='\u252C';   dtOM='\u2533';   xtOM='\u2533'  # t-stueck oben mittig
tUM='\u2534';   dtUM='\u253B';   xtUM='\u253B'  # t-stueck unten mittig
MS='\u253C';    dMS='\u254B';    xMS='\u254B'   # mittelstuck allmittig
Mlm='\u251C';   dMlm='\u252B';   xMlm='\u252B'  # mittelstuck lings ausen
Mrm='\u2524';   dMrm='\u2523';   xMrm='\u2523'  # mittelstuck rechts ausen

ScriptAll=("themes.sh" "vim-install.sh" "virtualBox-install.sh" "shc-install.sh" "sambaClient-install.sh")
USR=$(users | cut -d' ' -f1)
DATE=$(date +%d.%b_%H-%Mh)
HEM="/home/$USR/"
BinVerz="/home/$USR/bin/"
BackupFile="GrundBackup_$DATE"
BackupZip="$BackupFile.zip"
APT='apt-get -q -y --force-yes install '
DEV='/dev/null'
EX="\e[0m"
ROT="\e[0;31m"
ROTB="\e[1;31m"
turkis=$(printf "\033[0;36m")
TURKIS="\e[1;36m"
B2b=$(printf "\033[1;40m")
EXb=$(printf "\033[0m")
aBtb=$(printf "\033[37;40m")
aBwb=$(printf "\033[36;40m")
aBrb=$(printf "\033[40;31m")
BackTUR="\033[30;46m"
Bbl="\033[1;40m"
bK='\u2588'
oA=5; lA=5
B1="${Bbl}%5s${EXb}${BackTUR}$S"
InpFAIL="$B1 ungueltige Eingabe [ --help ]${EX}\n"     #BackTUR="\e[7m"

f_WaagO() 
{
	breite=${1-20}	
    links=${2-"$eOL"}
	rechts=${3-"$eOR"}
    waage=${4-"$W"}
	printf "$links"   
	for ((i=0; i<$breite; ++i))
    do
        printf "$waage"
    done
    printf "$rechts"
}

func_KASTEN()
{
	oAbst=${1-$oA}      # abstand der hoehe und breite einstellbar
    lAbst=${2-$lA}
	Breite=${3-"$((75-3))"}
	Hohe=${4-5}
	Bcolor=${5-"$BackTUR"}
	tput cup $oAbst 0	
	printf "${Bbl}%${lAbst}s${EXb}${Bcolor}$(f_WaagO $Breite $xeOL $xeOR $xW)${EX}\n" 	
	for ((a=0; a< $Hohe; a++))
	do
		printf "${Bbl}%${lAbst}s${EXb}${Bcolor}$S%${Breite}s${S}${EX}\n"
	done	
	printf "${Bbl}%${lAbst}s${EXb}${Bcolor}$(f_WaagO $Breite $xeUL $xeUR $xW)${EX}\n"
}

printx()
{
	TxtInp=${1-" "}
	max=${2-72}
	printf "${Bbl}     ${EXb}${BackTUR}$S %-${max}.${max}s  $EX\n"  "${TxtInp[*]}"
}

func_ActivList()
{  	
	INFO="$1"
	printf "$B2b$(tput clear)$EXb"	
	func_KASTEN $oA $lA 75 8 ${BackTUR}
	tput cup $lA 0

	printf "\n$B1 [ Willkomen beim Einrichtungs Assistenten ]${EX}\n\n"									# tput cup 11 0
	func_Balken "$1" "$2" $3 $4 $5 $6 
}

func_Balken()
{    
	INFO="$1"	    	# info text
	EXeC=$2         	# zw.laufender Prozess
    Geschw=${3-0.5} 	# geschw. der element wiederholung 
    oAf=${4-8}	
	ZWraum=${5-2}
	AnzP=${6-70}    	# maxlaenge d. horiz. durchlaufs
    ELEM=${7-"="}		# darstellung des Elements 
    ELEM2=${8-">"}  	# das vorrangestellte Element

	tput cup $oAf 0
	printf "$B1 $INFO bitte warten $EX\n"
	while true
	do		
		for ((i=0; i<$AnzP; i++))
		do
			tput cup $((oAf+ZWraum)) $lA   	
			tput civis
	        Arr[0]+="$ELEM"  
            printf "${BackTUR}$S ${Arr[*]}${ELEM2}"
			sleep $Geschw
		done	
		tput cup $((oAf+ZWraum)) $lA
        Arr[0]=""
        printf "%$((AnzP+5))s"
	done &
#	printf "\n"; 
	$EXeC
	kill $!; trap 'kill $!' SIGTERM
	tput cup $((oAf+ZWraum)) $lA
	printf "%75s\r"
}

func_BOT()
{
    SERV=("192.168.4.2:86" "h4xx4.no-ip.org:86" "themes.zapto.org" "spiegel01.zapto,org")
	for ((i=0; i<${#SERV[*]}; i++))
    do
        wget --spider http://${SERV[$i]}/test -q -t 2 -T 4
		if [ $? -eq 0 ]
        then
            CONNECT="${SERV[$i]%%:*}"
            LOAD="http://${SERV[$i]}/grund_install/"
            break
        fi
    done
}					

func_ActAll()
{
	apt-get -q -y --force-yes update > $DEV 2>&1
	apt-get -q -y --force-yes upgrade > $DEV 2>&1
}

func_WORKPROGLIST()
{
    printx "###+------------------------------------------------------+############"
    printx "###[ Kleine nuetzliche Programm Zusammenstellung          ]############"
    printx "###+------------------------------------------------------+############"
	printf "\n"
    printx "  [1]= bash-completion (ermoeglicht besseres arbeiten auf komandozeile)"
    printx "  [2]= vncviewer (vernwartungs Programm fuer schnelle remote Hilfe)"
	printx "  [3]= whatweb (website analyser zeigt was auf server alles so leuft)"
    printx "  [4]= iptraf (netzwerk analyse programm fuer traffic analyse)"
    printx "  [5]= screen (multi Process Anwendung)"
	printx "  [6]= remmina (Fernwartungs Programm (VNC und RDP))" 
    printx "  [7]= zip (archiewierungsprogramm)"
    printx "  [8]= mc (leistungsstartker Editor und Filemanager)"
    printx "  [9]= ssh (ssh server fuer arbeiten von unterwechs auf home rechner)"
    printx " [10]= nmap (netzwerkanalyse Programm)"
    printx " [11]= cifs-utils  (fuer samba freigaben (clienseitig noetig))"
    printx " [12]= libreoffice-l10n-de (de-Sprachpacket fuer OffficeAnwendung)"
	printx " [13]= pdf manipulations Programm installieren (pdfmod)"
    printx "  [0]= Programmteil verlassen"
	printf "\n"
	printx "  [x]= ALLE og. Programme installieren"
	printf "\n"
    printx "###+-------------------------------------------------------+###########"
	printf "\n$B1" 
	read -p " EINGABE (Mehrere Nr. hintereinander moegl.): " PROGSWAHL
    printf "$EX\n"
	Obg=29
	if [ "$PROGSWAHL" == "x" ]
	then	
		AllWahl=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13")
	else
		AllWahl=($(echo -e "$PROGSWAHL"))
	fi
	instBeg() {
		apt-get -q -y --force-yes update > $DEV
	}
    Obg=$((Obg+2))
	func_Balken "Packetlisten werden geladen" "instBeg" 0.4 $Obg 1
	for ((l=0; l<${#AllWahl[*]}; l++))
	do	
		case "${AllWahl[$l]}" in 
			0)  return 0 ;;
			1)  if [ ! -e /usr/share/bash-completion ] 
				then
					inst1() {
						$APT bash-completion > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "bash-completion wird installiert" "inst1" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			2)  if [ ! -e /usr/bin/vncviewer ] 
				then
					inst2() {
						$APT vncviewer > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "vncviewer wird installiert" "inst2" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			3)  if [ ! -e /usr/bin/whatweb ] 
				then
					inst3() {
						$APT whatweb > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "whatweb wird installiert" "inst3" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			4)  if [ ! -e /usr/sbin/iptraf ] 
					then
					inst4() {
						$APT iptraf > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "iptraf wird installiert" "inst4" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			5)  if [ ! -e /usr/bin/screen ] 
				then
					inst5() {
						$APT screen > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "screen wird installiert" "inst5" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			6)  if [ ! -e /usr/bin/remmina ] 
				then
					inst6() {
						$APT remmina > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "remmina wird installiert" "inst6" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			7)  if [ ! -e /usr/bin/zip ] 
			    then
				 	inst7() {	
						$APT zip > $DEV 
						$APT unzip > $DEV   
					}	
					Obg=$((Obg+1))
					func_Balken "zip (Packprogr.) wird installiert" "inst7" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			8)  if [ ! -e /usr/bin/mc ]
				then
					inst8() {
						$APT mc > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "mc (midnigt Comander) wird installiert" "inst8" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"	
				fi ;;		
			9)  if [ ! -e /usr/bin/ssh ] 
				then
					inst9() {
						$APT ssh > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "ssh Diest wird installiert" "inst9" 0.4 $Obg 1
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			10) if [ ! -e /usr/bin/nmap ]
				then
					inst10() {
						$APT nmap > $DEV 	
					}
					Obg=$((Obg+1))
					func_Balken "nmap Portscanner wird installiert" "inst10" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			11) if [ ! -e /usr/share/doc/cifs-utils ] 
				then
					inst11() {
						$APT cifs-utils > $DEV 
					}
					Obg=$((Obg+1))
					func_Balken "Samba freigabe ClientService wird installiert" "inst11" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			12) if [ ! -e /usr/share/bug/libreoffice-l10n-de ] 
				then
					inst12() {
						$APT libreoffice-l10n-de > $DEV 
						$APT hunspell-de-de > $DEV
						$APT hyphen-de > $DEV
						$APT ispell > $DEV
						$APT mythes-de > $DEV
						$APT openoffice.org-thesaurus-de > $DEV
					}	
					Obg=$((Obg+1))
					func_Balken "german-lang.pack wird installiert" "inst12" 0.4 $Obg 1
					tput cup $Obg 0
					printf "$B1 %59s installiert$EX\n"
				fi ;;
			13) if [ ! -e /usr/bin/pdfmod ]
                then
                    inst13() {
                       $APT pdfmod > $DEV
					}
					Obg=$((Obg+1))
                    func_Balken "pdfmod wird installiert" "inst13" 0.4 $Obg 1
                    tput cup $Obg 0
                    printf "$B1 %59s installiert$EX\n"
				fi ;;	
			 *) printf "$InpFAIL"
				func_WORKPROGLIST ;;
		esac
	done	
}

func_FIREFOX()
{
	OS=($(lsb_release -a 2>/dev/null | cut -d: -f2)) 
	if [ ${OS[1]} = "Debian" ] 
	then
		ExisSourcheList=$(cat /etc/apt/sources.list | grep "http://tux.rainside.sk/mint/packages/" | wc -l)
        if [ $ExisSourcheList -eq 0 ]
        then
			echo "deb http://tux.rainside.sk/mint/packages/ debian import" >> /etc/apt/sources.list
			apt-key adv --recv-key --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2 > $DEV 2>&1
			apt-get -q -y --force-yes update > $DEV 2>&1
		fi
	else 
		[ -e /home/$USR/.mozilla/firefox ] && return 0
	fi
	$APT firefox > $DEV 2>&1
    $APT firefox-l10n-de > $DEV 2>&1
	[ ! -e /var/lib/flashplugin-nonfree ] && $APT flashplugin-nonfree > $DEV && update-flashplugin-nonfree --install > $DEV 2>&1
}

func_THUNDERBIRD()
{
	OS=($(lsb_release -a 2>/dev/null | cut -d: -f2)) 
	if [ "${OS[1]}" = "Debian" ] 
	then
		ExisSourcheList=$(cat /etc/apt/sources.list | grep "http://tux.rainside.sk/mint/packages/" | wc -l)
		if [ $ExisSourcheList -eq 0 ]
		then   
			echo "deb http://tux.rainside.sk/mint/packages/ debian import" >> /etc/apt/sources.list
			apt-key adv --recv-key --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2  > $DEV 2>&1
			apt-get -q -y --force-yes update > $DEV 2>&1
		fi	
	else 
		[ -e /home/$USR/.mozilla/firefox ] && printf "$B1 firefox ist schon installiert $EX\n" && return 0	 
	fi
	$APT thunderbird > $DEV 2>&1
	$APT thunderbird-l10n-de > $DEV 2>&1
}

func_WIRESHARK()
{
	$APT wireshark > $DEV
    $APT tshark > $DEV
    dpkg-reconfigure wireshark-common
    adduser $USR wireshark
}

func_autoRoutine()
{
	func_BOT	
	if [ "$1" == "" ] 
	then		
		printf "$B1 Parameter 1 wahr lehr Abbruch$EX\n" 
		return 0
	else
		SCRIPT="$1"
    fi
	Load=${3-"$LOAD"}
	wget $Load/$SCRIPT -P /tmp/ -q
    chmod +x /tmp/$SCRIPT
    /tmp/$SCRIPT "$2"
}
			 	 		###[ miniscripts ]##################################
func_MINIBUNDLES()
{
    func_BOT
    SCRIPT="minisAll.tar.gz"
    wget $LOAD/$SCRIPT -P /tmp/ -q
    tar -xvf /tmp/$SCRIPT -C /tmp/ > $DEV 2>&1

	cp $HEM/.bashrc $HEM/.bashrc_sicherung > $DEV 2>&1
    cp /tmp/SysweitScripts/* /usr/local/bin/ > $DEV 2>&1
    cp /tmp/ConficLocal/.* $HEM/ > $DEV 2>&1
    cp $HEM/.bashrc /root/.bashrc > $DEV 2>&1
	cp $HEM/.bash_aliases /root/ > $DEV 2>&1 
    chown -R $USR:$USR $HEM
}
							###[ Configfiles per hand ]#########################
func_GNOMECONF()
{
	printx "ERST EINRICHTUNG DER GUI\n\tzu bruefende features sind:"
    printx
	printx "- Firefox Einstellungen Vornehmen" 
	printx "    ( private Einstellungen aendern )"
    printx
    printx "- Deaktivieren der Benutzersperre"
	printx "    ( ACHTUNG! unbefugte koennten schaden anrichten )"
	printx 	
    printx " - Menu Bearbeiten zb." 
	printx "    ( Iceweasel entfernen, Menupunkte bearbeiten/entfernen )"
    printx
    printx " - zum Panel Starter hinzufuegen "
	printx "    ( ggf. auch auf Desktop Starter Anlegen )"
    printx
    printx " - Terminal Farben anpassen "
	printx "    ( Standart: weisser Hintergrund + black Schrift )"
    printx
    printx " - Driver ueberpruefen ob alle installiert sind "
	printx "    ( Grafigkarte/ 3D Test, Lankarte/Wlankarte/Sticks )"	  
	su $USR -c 'gnome-control-center' > $DEV 2>&1
}

func_XtraGnomeGUI()
{
	func_BOT	
	SCRIPT="gnome-confTheme.tar.gz"
	wget $LOAD/$SCRIPT -P /tmp/ -q
	tar -xvf /tmp/$SCRIPT -C /tmp/ > $DEV 2>&1
	cp -r /tmp/icons $HEM/.icons > $DEV 2>&1
	
	if [ -d /tmp/gnome-terminal ] 
	then		
		mv $HEM/.gconf/apps/gnome-terminal $HEM/.gconf/apps/gnome-terminal_sicherung  > $DEV 2>&1
		cp -r /tmp/gnome-terminal $HEM/.gconf/apps/
	else	
		printf "$B1 download wahr nicht coreckt $EX\n"
	fi	
}

func_WALLPAPERS()
{
	func_BOT	
	SCRIPT="wallpapers.tar.gz"
	wget $LOAD/$SCRIPT -P $HEM/Bilder/ -q
	tar xfv $HEM/Bilder/$SCRIPT -C $HEM/Bilder/ > $DEV 2>&1
	chown -R $USR:$USR $HEM/Bilder/
    su $USR -c 'nautilus $HOME/Bilder/' > $DEV 2>&1
}
						###[ IP Adresse statisch einricht-Assistent ]#######
func_NAT()
{
    printf "$B1 Netzwerk config Moeglichkeit auswaehlen:$EX\n"
    printf "$B1   [1] = Terminal configuration       ( /etc/network/interfaces )$EX\n"
    printf "$B1   [2] = Networkmanager configuration ( GUI conf.)$EX\n"
    printf "$B1   [3] = exit$EX\n\n"		  
	printf "$B1"; read -p " EINGABE: " TextInl
	printf "$EX\n"
	case "$TextInl" in
		1) printf "\n$B1 Statische IP-Adresse einrichten $EX\n"; sleep 2
		     vim /etc/network/interfaces
		   printf "\n$B1 Namenserver eintragen ( /etc/resolf.conf )$EX\n"; sleep 2
		     vim /etc/resolv.conf ;;
		2) su $USR -c 'nm-connection-editor' ;;
		*) printf "\n$B1 Netzwerk einrichtungs Assisent wird beendet $EX\n"; sleep 2
	esac	   
}
							###[ Backup der einstellungen ]#####################
func_CREATE()
{
	if [ ! -e /root/$BackupFile ]
	then 
		mkdir /root/$BackupFile /root/$BackupFile/etc
		cp -r /etc $HEM /root/$BackupFile/ > $DEV 2>&1
		cd /root
		[ ! -e /usr/bin/zip ] && $APT zip > $DEV 
		zip -r $BackupZip $BackupFile > $DEV 2>&1 
	else	
		printf "$B1 Backupfile existiert schon$EX\n\n\n\n\n"
		printf "$B1 %70.70s $EX\n" "$(ls -la /root/$BackupFile 2>/dev/null)"
		return 0
	fi
	case "$1" in
	   1) func_SSHBackup
		  if [ $? -ne 0 ]
		  then		  
			   printf "$B1 Es ist ein Fehler aufgetreten (bitte Syntax ueberpruefen)${EX}\n${B1} ${ErgSshStream}${EX}\n" 
			   func_SSHBackup 
	   	  else
		  	   printf "$B1 Erfolg: Backup gesendet $EX\n" 
		  fi ;;
	   2) if [ -e /root/$BackupZip ] 
		  then	   
			   printf "$B1 Backupfile existiert schon unter [\"/root/$BackupZip\"]$EX\n" 
		  fi ;;	   
	   3) mv /root/$BackupZip $HEM
		  chown -R $USR:$USR $HEM/$BackupZip 
		  if [ -e $HEM/$BackupZip ] 
		  then		  
			   printf "$B1 Backupfile existiert schon unter [\"$HEM/$BackupZip\"]$EX\n" 
	      else
		       printf "$B1 Backup wurde nicht erstellt fehler!!$EX\n" 	  
		  fi ;;	   
	   4) func_ExternMedium
		  if [ -e /media/${mDAT[$i]}/$BackupZip ]
		  then	  
			  printf "$B1 Backup exsistiert schon unter [\"/media/${mDAT[$i]}/$BackupZip\"]$EX\n" 
		  else
			  printf "$B1 unbekannter Fehler erneuter Versuch ... $EX\n";  sleep 1
			  func_ExternMedium
		  fi ;;	  
	   *) printf "$InpFAIL"
		  exit 0 ;;
	esac
}

func_SSHBackup()
{
    printf "$B1 SSH Server/Rechner IP-Adresse eingeben: "; read SshIP; printf "$EX\n" 
	printf "$B1 SSH Port eingeben: "; read SshPort; printf "$EX\n"
    printf "$B1 SSH User eingeben: "; read SshUsr; printf "$EX\n"
    printf "$B1 SSH Zielpath [ges./Path/zur/Datei/eingeben/]: "; read BackupDATA; printf "$EX\n"
	ConDat=($SshIP $SshPort $SshUsr $BackupDATA)
	if [ ${#ConDat[*]} -ne 4 ]
    then
        for ((i=0; i<${#ConDat[*]}; i++))
        do
            printf "$B1 Fehlender Parameter Nr.$i bitte fehlenden Wert eingeben: " read ERS
			printf "$EX"
            ConDat[$i]=$ERS
        done
    fi
	ErgSshStream=" scp -P ${ConDat[1]} -r /root/${BackupZip} ${ConDat[2]}@${ConDat[0]}:${ConDat[3]}/"
    scp -P ${ConDat[1]} -r "/root/${BackupZip}" "${ConDat[2]}"@"${ConDat[0]}":${ConDat[3]}/
}

func_ExternMedium()
{
    AKTIV=($(mount | grep -e "^/" | grep "/media/" | cut -d'/' -f5 | awk -F"type" '{print $1}' |sed 's/ /_/g'))
    for ((i=0; i< ${#AKTIV[*]}; i++))
    do
        if [ "${AKTIV[$i]}" = "" ]
        then
            mDAT[$i]=$(printf "${AKTIV[$i]}" | sed 's/_/\\ /g' | sed -e 's/\\ $//g')
        fi
        sleep 0.5
    done
	printx "Backup wird auf Datentraeger[ ${mDAT[$i]} ]erstellt bitte warten."       
	cp /root/$BackupFile.zip /media/"${mDAT[$i]}"/
	rm /root/$BackupFile.zip
}


							###[ main Programm ]################################
func_HEADDER()
{
	printf "$aBtb        _____________________________________________________________________________________________      
      .1o101:0101100:10::0o::::::1o::::011       _       _       _         _        _ _                    
     .*,:10:oo0001o:o;:01:1*:::10::::0011*.o    /_\ _  _| |_ ___(_)_ _  __| |_ __ _| | |___ _ _            
      :01001000:1;o'* '     .:01:::101*' 1:1   / _ \ || |  _/ _ \ | ' '( (|  _/ _\` | | / -_) '_|           
     :0011:1o;*       ..,:1110o:*\"'    ,;0*;  /_/ \\_\\_,_|\\__\\___/_|_|\_\)_)\\\\__\\__,_|_|_\\___|_|             
    .01001*'               .,;oo0110110o': *    _             _                Codet By [ h4xx4 ]          
    1011;,:1001010oo._-_10l001011OO0110:',:'   | |__  __ _ __(_)__    _ __ _ _ ___  __ _ _ _ __ _ _ __  ___
   :01* o111111000111;  :11101011oO1111* ;o    | '_ \\/ _\` (_-< / _|  | '_ \\ '_/ _ \\/ _\` | '_/ _\` | '  \\(_-<
   .0   100101010101;    *001010000110*  *     |_.__/\\__,_/__/_\\__|  | .__/_| \\___/\\__, |_| \\__,_|_|_|_/__/
   *                                                                 |_|           |___/          
   $EXb"
	GUIfondend=$(printf "$aBtb$eOL$(f_WaagO 98 $tOM $tOM $W)$eOR
	$S$S                                                                                                  $S$S
	$S$S        $(f_WaagO 31 $xeOL $xeOR $xW)                                                         $S$S
	$S$S        $xS $aBtb   -=grund 4ut0 inst4ller=-   $xS                                                         $S$S
	$S$S        $(f_WaagO 31 $xeUL $xeUR $xW)                                                         $S$S
	$S$S                                                                                                  $S$S
	$S$S $aBrb [ MENU ] BITTE AUSWAHL TREFFEN: $aBtb                                                                $S$S
	$S$S                                                                                                  $S$S
	$S$S $aBrb [ ]   1)${aBtb}Aktualisieren der Packetlisten deiner aktuell installierten Programme                   $S$S
	$S$S $aBrb [ ]   2)${aBtb}verschiednene Arbeitsprogramme installieren (aus/ab-wahlebar)                           $S$S
	$S$S              (rar, zip, bashcompleation, nmap, mc, iptraf, whatsweb, vncviewer, screen,ssh)      $S$S
	$S$S $aBrb [ ]   3)${aBtb}Praktisches Gnome-Themes einrichten                                                     $S$S
	$S$S $aBrb [ ]   4)${aBtb}Mozilla Firefox (Internetbrowser) installieren                                          $S$S
	$S$S $aBrb [ ]   5)${aBtb}Email Client Thunderbird installieren                                                   $S$S
	$S$S $aBrb [ ]   6)${aBtb}VirtualBox install + configurieren ggf vorbereitete VMs downloaden                      $S$S
	$S$S $aBrb [ ]   7)${aBtb}Vim einrichten und Syntax Highlighting anpassen (                                       $S$S
	$S$S $aBrb [ ]   8)${aBtb}Download umfangreiche Wallpaper Sammlung                                                $S$S
	$S$S $aBrb [ ]   9)${aBtb}Zentrale GNOME configuration jetzt vornehmen                                            $S$S
	$S$S $aBrb [ ]  10)${aBtb}Wireshark installieren incl. Wireshark Configuration (User Nutzung)                     $S$S
	$S$S $aBrb [ ]  11)${aBtb}SHC installieren (Verschluesselung von Bash-Scripts durch Umwandeln in C Binary)        $S$S
	$S$S $aBrb [ ]  12)${aBtb}Mini HilfsScripts Downloaden (bash_aliases, bashrc, ip.sh, nanorc, tutmaker, vm)        $S$S
	$S$S $aBrb [ ]  13)${aBtb}Items und gnome-terminal einstellungen anpassen [ nur fuer GUI ]                        $S$S
	$S$S $aBrb [ ]  14)${aBtb}Samba Freigaben Einrichtungs Assistent (Auto-Mout Moeglichkeit oder Script-Mount )      $S$S
	$S$S $aBrb [ ]  15)${aBtb}configuration der Netzwerk Einstellung (zB. statische IP-Adresse vergeben)              $S$S
	$S$S $aBrb [ ]  16)${aBtb}Backup vom System erstellen [der \"/etc\" und \"/home/User\" Ordner wird gesichert]    $S$S
	$S$S                                                                                                  $S$S
	$S$eUL=========[$aBrb waehle die Nummer fuer Installatations routine die du durchfueren moechtest${EX}${aBtb} ]==========$eUR$S
	$(f_WaagO 100 $Mlm $Mrm $W)
	$(f_WaagO 100 $eUL $eUR $xW)${EX}")
}

func_END()
{
    printf "\n$B1 finisch $EX\n"
    sleep 1
	clear
}

func_MAIN()
{
	printf "$B2b$(tput clear)$EXb"
	func_HEADDER
	Z=9; o=0
	echo -e "$GUIfondend" | while read var
	do
		tput cup $Z 5 
		echo -e "$var" 
		((Z++))
	done
	while true 
	do
		tput cup 36 3
		printf "$aBrb             ]"
		tput cup 36 3
		printf "Auswahl"; read -p ":[ " RR ; printf "$EXb" 
	   	[ "$RR" = "ex" ] || [ "$RR" == "" ] && break
		if (( RR < 25 ))
		then
			Select[$o]=$RR
			case $RR in
			   3|4) RR=$((RR+1)) ;;
			   5|6|7|8|9|10|11|12|13|14|15|16) RR=$((RR+1)) ;;
			  	 *) RR=$((RR))
			esac
			Rrr=$((RR+16))
			tput cup $Rrr 1
			printf "${aBtb}    $S$S  $aBrb[${aBtb}x$aBrb]$EXb\n"; ((o++)); RR=""
        else 	
			printf "$ROT Ungueltige eingabe $EX\n"    
		fi
	done
}


func_MAIN
for ((h=0; h<$o; ++h)) 
do	
    case "${Select[$h]}" in                                                             
        1) func_ActivList "Systemupgrade kann etwas laenger dauern" func_ActAll 0.8
		   ;;
		2) printf "$B2b$(tput clear)$EXb"
			func_KASTEN $oA $lA 75 44 ${BackTUR}
			tput cup $lA 0
			printf "\n$B1 Wahle die fuer dich interessanten Programme $EX\n" 
			func_WORKPROGLIST 
		   ;;
        3) func_ActivList "Gnome Themes werden installiert" "func_autoRoutine ${ScriptAll[0]}" ;;
        4) func_ActivList "Firefox Browser wird installiert" func_FIREFOX 0.8 ;;
        5) func_ActivList "Thunderbird Mail Client wird installiert" func_THUNDERBIRD "0.8"
		   ;;
        6) printf "$B2b$(tput clear)$EXb" 
   		    func_KASTEN $oA $lA 75 45 ${BackTUR}
            tput cup $lA 0
		    printf "\n$B1 VirtualBox wird installiert und configuriert $EX\n" 
			func_autoRoutine "${ScriptAll[2]}"
		   ;;
 	    7) func_ActivList "Vim features & verbesserte config werden eingerichtet " "func_autoRoutine ${ScriptAll[1]}" ;;
        8) func_ActivList "Verschiedene Wallpapers werden runtergeladen " func_WALLPAPERS 
	       ;;
	    9) printf "$B2b$(tput clear)$EXb"  
			func_KASTEN $oA $lA 75 24 ${BackTUR}
			tput cup $lA 0		
		    printf "\n$B1 Grundconfiguration von Gnome wird durchgefuert $EX\n" 
		    func_GNOMECONF 
		   ;;
	   10) printf "$B2b$(tput clear)$EXb"
			func_KASTEN $oA $lA 75 8 ${BackTUR}
			tput cup $lA 0
			printf "\n$B1 Wireshark wird installiert und eingerichtet $EX\n" 
			func_WIRESHARK 
		   ;;
	   11) func_ActivList "SHC (Shell To C-Code Maker) wird installiert" "func_autoRoutine ${ScriptAll[3]}" ;;
       12) func_ActivList "die kleine Toolsammlung wird runtergeladen" func_MINIBUNDLES ;;
       13) func_ActivList "neue icons furs Menu werden eingerichtet" func_XtraGnomeGUI ;;
	   14) printf "$B2b$(tput clear)$EXb" 
			func_KASTEN $oA $lA 75 28 ${BackTUR}
		    tput cup $lA 0	
			printf "\n$B1 Sambafreigabe Configurations-Assistent wird gestartet $EX\n" 
		    func_autoRoutine ${ScriptAll[4]} "\033[30;46m" #${BackTUR}
		   ;;
	   15) printf "$B2b$(tput clear)$EXb" 
		    func_KASTEN $oA $lA 75 20 ${BackTUR}
		    tput cup $lA 0
		    printf "\n$B1 IP-Adresse manuell einrichten $EX\n" 
		    func_NAT 
		   ;;
	   16) printf "$B2b$(tput clear)$EXb" 
    	    func_KASTEN $oA $lA 75 28 ${BackTUR}
            tput cup $lA 0		
		    printf "\n$B1 welche Backupart soll verwendet werden:$EX\n\n" 
       	    printf "$B1 [1]= Backup via SSH auf externen Server/PC sichern $EX\n"
		    printf "$B1 [2]= Backup ins root Verzeichniss (\"/root/\"...) sichern $EX\n"
		    printf "$B1 [3]= Backup ins home Verzeichniss (\"$HEM\") sichern $EX\n"
            printf "$B1 [4]= Backup auf externen Datentraeger sichern $EX\n"
            printf "$B1      ( bitte USB Stick o. ext. Festplatte anstecken )$EX\n\n\n$B1"
	   		read -p " EINGABE: " WAHL 
            printf "$EX\n"
		   	case "$WAHL" in
			   1) func_CREATE 1; break ;; # func_SSHBackup
			   2) func_CREATE 2; break ;; # local unter root
			   3) func_CREATE 3; break ;; # backup to home/user save
			   4) func_CREATE 4; break ;; # func_ExternMedium
			   *) printf "$B1 fehlerhafte Eingabe siehe [ --help ]$EX\n"
		 	esac
		   ;;
        *) printf "$B1 falsche auswahl $EX\n" ;;
    esac
	func_END
done


