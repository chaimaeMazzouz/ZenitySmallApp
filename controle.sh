#!/bin/bash
height=200
width=400
emptyError(){
	#on va pas valider les error des options ou des argument parce qu'il peut etre des error de permission
        #ou d'autres qu'il est mieux de les afficher au l'utilisateur
	zenity --error --title="Error" --text="Il faut remplir le champs $1"
}
findCommand(){
   #On crée le formulaire de FIND
   findRes=`zenity --forms --height=$height --width=$width\
    --title="La commande FIND" \
    --text="Définir les options de la commande find" \
    --add-entry="Path(Chemin) :" \
    --add-entry="-iname :" \
    --add-entry="-type :"`
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi

   Path=$(echo "$findRes" | cut -d"|" -f1)
   Iname=$(echo "$findRes" | cut -d"|" -f2)
   Type=$(echo "$findRes" | cut -d"|" -f3)
   #valider c'est les champs sont rempli
   if [ -z $Path ];then
	   emptyError "Path(Chemin)"
	   findCommand
   elif [ -z $Iname ];then
	   emptyError "-iname"
	   findCommand
   elif [ -z $Type ];then
	   emptyError "-type"
	   findCommand
   fi
   find $Path -type $Type -name "$Iname" &> res.txt
}

cutCommand(){
   #On crée le formulaire de CUT
   cutRes=`zenity --forms --height=$height --width=$width\
    --title="La commande CUT" \
    --text="Définir les options de la commande cut" \
    --add-entry="Le nom de fichier :" \
    --add-entry="Options :" \
    --add-entry="-type :"`
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi

   fileName=$(echo "$cutRes" | cut -d"|" -f1)
   optionCut=$(echo "$cutRes" | cut -d"|" -f2)
   typeCut=$(echo "$cutRes" | cut -d"|" -f3)
    if [ -z $fileName ];then
           emptyError "Le nom de fichier"
           cutCommand
   elif [ -z $optionCut ];then
           emptyError "Options"
           cutCommand
   elif [ -z $typeCut ];then
           emptyError "-type"
           cutCommand
   fi

   cut -d"$typeCut" $optionCut $fileName &> res.txt
}
grepCommand(){
	#On crée le formulaire de GREP
    grepRes=`zenity --forms --height=$height --width=$width\
    --title="La commande GREP" \
    --text="Définir les options de la commande grep" \
    --add-entry="Pattern/motif de recherche :" \
    --add-entry="Path du fichier :" \
    --add-entry="Nom du fichier :" \
    --separator="~"`
   #il faut utiliser ~ comme separteur pour eviter les error de Regex et aussi de savoir si les champs vide
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi
   pattern=$(echo $grepRes | cut -d"~" -f1)
   pathFichier=$(echo $grepRes | cut -d"~" -f2)
   nomFichier=$(echo $grepRes | cut -d"~" -f3)
   if [ -z $pattern ];then
           emptyError "Pattern/motif de recherche"
           grepCommand
   elif [ -z $pathFichier ];then
           emptyError "Path du fichier"
           grepCommand
   elif [ -z $nomFichier ];then
           emptyError "Nom du fichier"
           grepCommand
   fi
   egrep "$pattern" $pathFichier/$nomFichier &> res.txt
}
selectCommand(){
	ans=`zenity --entry --title="La commande" --height=$height --width=$width\
        --text="Veuillez indiquer l'une des trois commandes:" --entry-text="GREP" FIND CUT`;
	if [ $? = 1 ];then
		if $(zenity --question --text "Sur vous voullez quitter?");then
			exit;
		else
			selectCommand
		fi
	fi
	if [ $ans = "FIND" ];then
		findCommand
	elif [ $ans = "CUT" ];then
		cutCommand
	elif [ $ans = "GREP" ];then
		grepCommand
	else
		zenity --error \
			--title="Error"\
			--text"Invalid Choix"
		selectCommand
	fi

}
selectCommand

zenity --text-info --width="700" --height="500" \
--title "Voici les résultats de votre commande" \
--filename "res.txt"

