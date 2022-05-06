#!/bin/bash
ans=`zenity --entry --title="La commande" \
--text="Veuillez indiquer l'une des trois commandes:" --entry-text="GREP" FIND CUT`
#Si on clique sur le bouton Annuler
if [ "$?" -eq 1 ]; then
   zenity --question --text "Sur vous voullez quitter?" --no-wrap --ok-label "Yes" --cancel-label "No"
   if [ "$?" -eq 1 ]; then
    ans=`zenity --entry --title="La commande" \
     --text="Veuillez indiquer l'une des trois commandes:" --entry-text="GREP" FIND CUT`
   else
      exit
   fi
fi
if [ $ans = "FIND" ]; then
  #On crée le formulaire de FIND
    findRes=`zenity --forms \
    --title="La commande FIND" \
    --text="Définir les options de la commande find" \
    --add-entry="Path(Chemin) :" \
    --add-entry="-iname :" \
    --add-entry="-type :" \
    --separator=":"`
   Path=$(echo "$findRes" | cut -d ":" -f1)
   Iname=$(echo "$findRes" | cut -d ":" -f2)
   Type=$(echo "$findRes" | cut -d ":" -f3)
   res=$(find $Path -type $Type -name "$Iname" > res.txt)
elif [ $ans = "CUT" ]; then
     #On crée le formulaire de CUT
    cutRes=`zenity --forms \
    --title="La commande CUT" \
    --text="Définir les options de la commande cut" \
    --add-entry="Le nom de fichier :" \
    --add-entry="Options :" \
    --add-entry="-type :" \
    --separator=":"`
   fileName=$(echo "$cutRes" | cut -d ":" -f1)
   optionCut=$(echo "$cutRes" | cut -d ":" -f2)
   typeCut=$(echo "$cutRes" | cut -d ":" -f3)
   res=$(cut $optionCut $typeCut  $fileName > res.txt)
elif [ $ans = "GREP" ]; then
     #On crée le formulaire de GREP
    grepRes=`zenity --forms \
    --title="La commande GREP" \
    --text="Définir les options de la commande grep" \
    --add-entry="Pattern/motif de recherche :" \
    --add-entry="Path du fichier :" \
    --add-entry="Nom du fichier :" \
    --separator=":"`
   pattern=$(echo "$grepRes" | cut -d ":" -f1)
   pathFichier=$(echo "$grepRes" | cut -d ":" -f2)
   nomFichier=$(echo "$grepRes" | cut -d ":" -f3)
   res=$(egrep "$pattern" $pathFichier/$nomFichier > res.txt )
fi
zenity --text-info \
--title "Voici les résultats de votre commande" \
--filename "res.txt"
#!/bin/bash
res=""
findCommand(){
   #On crée le formulaire de FIND
   findRes=`zenity --forms \
    --title="La commande FIND" \
    --text="Définir les options de la commande find" \
    --add-entry="Path(Chemin) :" \
    --add-entry="-iname :" \
    --add-entry="-type :" \
    --separator=":"`
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi

   Path=$(echo "$findRes" | cut -d ":" -f1)
   Iname=$(echo "$findRes" | cut -d ":" -f2)
   Type=$(echo "$findRes" | cut -d ":" -f3)
   find $Path -type $Type -name "$Iname" &> res.txt
}

cutCommand(){
   #On crée le formulaire de CUT
   cutRes=`zenity --forms \
    --title="La commande CUT" \
    --text="Définir les options de la commande cut" \
    --add-entry="Le nom de fichier :" \
    --add-entry="Options :" \
    --add-entry="-type :" \
    --separator=":"`
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi

   fileName=$(echo "$cutRes" | cut -d ":" -f1)
   optionCut=$(echo "$cutRes" | cut -d ":" -f2)
   typeCut=$(echo "$cutRes" | cut -d ":" -f3)
   cut $optionCut $typeCut  $fileName &> res.txt
}
grepCommand(){
	#On crée le formulaire de GREP
    grepRes=`zenity --forms \
    --title="La commande GREP" \
    --text="Définir les options de la commande grep" \
    --add-entry="Pattern/motif de recherche :" \
    --add-entry="Path du fichier :" \
    --add-entry="Nom du fichier :" \
    --separator=":"`
   #pour le button Cancel on va quetter
   if [ $? = 1 ];then
           exit
   fi

   pattern=$(echo "$grepRes" | cut -d ":" -f1)
   pathFichier=$(echo "$grepRes" | cut -d ":" -f2)
   nomFichier=$(echo "$grepRes" | cut -d ":" -f3)
   egrep "$pattern" $pathFichier/$nomFichier &> res.txt
}
selectCommand(){
	ans=`zenity --entry --title="La commande" \
        --text="Veuillez indiquer l'une des trois commandes:" --entry-text="GREP" FIND CUT`;
	echo $?
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
zenity --text-info \
--title "Voici les résultats de votre commande" \
--filename "res.txt"

