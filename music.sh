#!/bin/bash
#utf-8
#####################################################################
#
# script name: music.sh
# created in: 06/23/22
# modified in: 15:08:38
#
# summary: api from letras.mus.br
#                                               developed by: bates
#####################################################################
#variables

clear
#variables

PAM=$1

if [ $(uname) = "Linux" ]; then

    sudo apt-get update -y > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    sudo apt-get install curl  > /dev/null 2> /dev/null

    sudo apt-get install jq > /dev/null 2> /dev/null

    #game
elif [ $(uname) = "Darwin" ]; then
    sudo apt-get update -y > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    /usr/bin/ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install) > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    brew install jq > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    brew install coreutil > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    #game
fi


if [ $PAM ]; then
    if [ $PAM = "--help" ] 2>/dev/null; then
        echo "#============================= HELP COMMANDS ============================================#"
        echo "# This program helps to download music lyrics from the Letras.mus.br.                    # "
        echo "# He receives only two inputs from his user; 1) Band, 2) music.                          #"  
        echo "# If you don't know the name of the song, you can get some suggestions by typing the:    #"
        echo "# sh music.sh --suggestion                                                               #"
        echo "#========================================================================================#"
    fi

    if [ $PAM = "--version" ] 2>/dev/null; then
        echo "#=========================== VERSION ==================================================#"
        echo "# Version 1.0.0                                                                        #"
        echo "#======================================================================================#"
        echo ""
        echo "#======================================================================================#"
        echo "# To learn more about the program enter the command                                    #"
        echo "# sh music.sh --help                                                                   #"
        echo "#======================================================================================#"
    fi


    if [ $PAM = "--suggestion" ] 2>/dev/null; then
        clear
        echo "#########################################################################################################################"
        read -p "Enter the name of the band, or musician you want to receive a suggestion? " BAND
        echo "#########################################################################################################################"
        BANDI=$(echo "$BAND" | sed 's/ /-/g')
        URL="https://www.letras.mus.br/$BANDI/"
        ACTION=$(    curl -s -L https://www.letras.mus.br/$BANDI/ | grep -i "data-sharetext=" | sed "s/<[^>]*>/\n/g" | sed "1, 61 d" |  grep -v "^$"  | sed 's/\&#39;/ /g' | sed '/^[[:space:]]*$/d' | head -n15)

        echo "=========================================== SUGGESTION ======================================================================="
        echo ""
        echo "$ACTION"
        echo ""
        echo "==============================================================================================================================="
        echo ""
        read -p "Do you want to save some letter? (Y/n): " OPT

        if [ "$OPT" = "Y" -o "$OPT" = "y" -o "$OPT" = "" ]; then
            clear
            echo "############################################################################"
            read -p "What song do you want to save? " MUSIC
            MUSICI=$(echo "$MUSIC" | sed 's/ /%20/g')
            MUSICA=$(echo "$MUSIC" | sed 's/ /-/g')
            URL="https://www.letras.mus.br/$BANDI/$MUSICI"
            if curl -s $URL > /dev/null 
            then
                echo "############################################################################"
                mkdir -p save/
                DIR=save/
                chmod -R 777 $DIR
                echo "############################################################################"
                sleep 1
                clear
                echo "################### $BAND-$MUSIC #######################################################" > $DIR/$BANDI-$MUSICA.txt
                curl -s -L $URL | grep 'cnt-letra p402_premium'  | sed "s/<[^>]*>/\n/g;s/Adicionar.*Criar//g" >> $DIR/$BANDI-$MUSICA.txt
                echo "##############################################################################################################################################"
                echo "The file $DIR/$BAND-$MUSIC.txt was created with success!"
                echo "##############################################################################################################################################"
            else
                echo "#######################################################################"
                echo "The $MUSIC was not found!"
                echo "#######################################################################"
            
            fi
        elif [ "$OPT" = "N" -o "$OPT" = "n" ]; then
            echo "#######################################################################"
            echo "OK, thanks"
            echo "#######################################################################"
        else
            echo "#######################################################################"
            echo "Command was not recognized!"
            echo "#######################################################################"
        fi

    fi
else
    if [ music.sh ] 2>/dev/null; then
        echo "#############################################################################"
        read -p "Enter the name of the band or musician? " BAND
        echo "#############################################################################"
        sleep 1
        clear
        echo "#############################################################################"
        read -p "Enter the name of the Music: " MUSIC
        echo "#############################################################################"
        sleep 1
        clear
        BANDI=$(echo "$BAND" | sed 's/ /-/g')
        MUSICI=$(echo "$MUSIC" | sed 's/ /%20/g')
        MUSICA=$(echo "$MUSIC" | sed 's/ /-/g')
        URL="https://www.letras.mus.br/$BANDI/$MUSICI"
        if curl -s $URL > /dev/null 
        then
            mkdir -p save/
            DIR=save/
            chmod -R 777 $DIR
            clear
            echo "################### $BAND-$MUSIC #######################################################" > $DIR/$BANDI-$MUSICA.txt
            curl -s -L $URL | grep 'cnt-letra p402_premium'  | sed "s/<[^>]*>/\n/g;s/Adicionar.*Criar//g" >> $DIR/$BANDI-$MUSICA.txt
            echo "##############################################################################################################################################"
            echo "The file $DIR/$BAND-$MUSIC.txt was created with success!"
            echo "##############################################################################################################################################"
        else
            echo "#######################################################################"
            echo "The file The $BAND or $MUSIC was not found!"
            echo "#######################################################################"
        
        fi
        read -p "Do you want to make another query? (Y/n): " REPET
        if [ "$REPET" = "Y" -o "$REPET" = "y" -o "$REPET" = "" ]; then
            echo "#######################################################################"
            sleep 1
            echo "ok"
            sleep 1
            sh music.sh
        else
            echo "#######################################################################"
            sleep 1
            echo "ok"
            sleep 1
            echo "Thanks"
            echo "########################################################################"
        fi

    fi
fi