#!/bin/bash
wins=0
bag=0
xdoor=$(( $RANDOM % 5 + 2 ))
ydoor=$(( $RANDOM % 5 + 2 )) 

xdoorflip=$(( $RANDOM % 2 ))

if [[ $xdoorflip == 1 ]]; then
  xdoor=$((0 - $xdoor))
fi
xtreasure=$(( $RANDOM % 2 + 1 ))
ytreasure=$(( $RANDOM % 2 + 1 )) 

xtreasureflip=$(( $RANDOM % 2 ))

if [[ $xtreasureflip == 1 ]]; then
  xtreasure=$((0 - $xtreasure))
fi
ytreasureflip=$(( $RANDOM % 2 ))

if [[ $ytreasureflip == 1 ]]; then
  ytreasure=$((0 - $ytreasure))
fi

NPCstartx=0
NPCstarty=0

NPCrun=$(($RANDOM % 3))
case "$NPCrun" in
	0)
		NPCstartx=3
    NPCrun="east"
  ;;
  1)
    NPCstarty=-3
    NPCrun="south"
  ;;
  2)
		NPCstartx=-3
    NPCrun="west"
  ;;
esac

position=(0 0)
door=($xdoor $ydoor)
treasure=($xtreasure $ytreasure)
inventory=()
NPC=($NPCstartx $NPCstarty)

function _fight {
  echo " \"p\" punch"
  echo " \"b\" block"
  echo " \"g\" grab"

  read fightmove
  
  case "$fightmove" in
    [pP] | [pP]"unch")
      fightmove="p" 
    ;;
    [bB] | [bB]"lock")
      fightmove="b"
    ;;
    [gG] | [gG]"rab")
      fightmove="g"
    ;;
  esac
 
  NPCmove=$(( $RANDOM % 3 )) 

  case "$NPCmove" in
    0)
      NPCmove="p" 
    ;;
    1)
      NPCmove="b"
    ;;
    2)
      NPCmove="g"
    ;;
  esac
 
  if [[ $fightmove == "p" && $NPCmove == "p" ]]; then
    echo "You clash in combat without a clear winner"
    ((position[1]=position[1]+1))
    echo "You retreate north"

  elif [[ $fightmove == "b" && $NPCmove == "b" ]]; then
    echo "You bothe are do defencive and nothing hapends" 
    ((position[1]=position[1]+1))
    echo "You retreate north"

  elif [[ $fightmove == "g" && $NPCmove == "g" ]]; then
    echo "You wresl for a while but you bothe survive"
    ((position[1]=position[1]+1))
    echo "You retreate north"
 
  elif [[ $fightmove == "p" && $NPCmove == "g" ]]; then
    echo "One mighty blow and he falls"
    wins=1

  elif [[ $fightmove == "b" && $NPCmove == "p" ]]; then
    echo "You block his strike and the counter hit kills him"
    wins=1

  elif [[ $fightmove == "g" && $NPCmove == "b" ]]; then
    echo "your gohstly grasp takes hold and suficates him"
    wins=1

  elif [[ $fightmove == "g" && $NPCmove == "p" ]]; then
    echo "as you aproch he stikes you down he laughs"
    echo "Go back to the grave from once you came" | pv -qL 19 
    echo "YOU DIED" | pv -qL 8
    exit

  elif [[ $fightmove == "p" && $NPCmove == "b" ]]; then
    echo "He blocks and counters you fall he mutters"
    echo "Go back to the grave from once you came" | pv -qL 19 
    echo "YOU DIED" | pv -qL 8
    exit

   elif [[ $fightmove == "b" && $NPCmove == "g" ]]; then
    echo "your on the defensive but he overwelms you and you fall"
    echo "Go back to the grave from once you came" | pv -qL 19 
    echo "YOU DIED" | pv -qL 8
    exit

  fi
 
}

function _help {
  echo "the commands are"
  echo "h, this menu"
  echo "n, move north "
  echo "s, move south "
  echo "e, move east "
  echo "w, move west"
  echo "t, take item "
  echo "i, invernory "
  echo "p, position"
  echo "f, how to fight"
}

function light {
  echo "I can see a light from the $1"
}

function treasure {
  if [[ $1 -eq ${treasure[0]} && $2 -eq ${treasure[1]} ]]; then
    echo "you take some treasure"
    inventory+=("treasure") 
    treasure=(100 -100)
    ((bag++))
  else
    echo "I don't see anything hear to take"
  fi
}


echo "--------------------------------------"
echo "  You are a spirit escaping the caves"
echo "  of the damned there is a light to "
echo "  the North "
echo "  a man sees you and screams "
echo "  \"GHOST\"" | pv -qL 20 
echo "  He runs $NPCrun"
echo "  you smell treasure nearby"
echo "  You can quit any time with \"quit\""
echo "--------------------------------------"
echo ""

leave=0
while [[ $leave == 0 ]]; do
  echo "  what would you like to do \"h\" for help"
  echo "  you are at (${position[0]},${position[1]})"
  echo""
  read command
  case "$command" in
    [qQ] | [qQ]"uit")
      echo "---> Thank you for playing"
      echo ""
      exit
      ;;
    [nN] | [nN]"orth")
      echo "you go north"
      ((position[1]=position[1]+1))
      ;;

    [sS] | [sS]"outh")
      echo "you go south"
      ((position[1]=position[1]-1))
      ;;

    [eE] | [eE]"ast")
      echo "you go east"
      ((position[0]=position[0]+1))
      ;;

    [wW] | [wW]"est")
      echo "you go west"
      ((position[0]=position[0]-1))
      ;;
    
    [tT] | [tT]"ake")
      treasure ${position[0]} ${position[1]}
      ;;
    
    [hH] | [hH]"elp")
      _help
      ;;

    [iI] | [iI]"nventory")
      if [[ $bag != 0 ]]; then
        echo "you are carrying ${inventory[@]}"
      else
        echo "you are not carrying anything"
      fi
      ;;

    [pP] | [pP]"osition")
      echo "  you are at (${position[0]},${position[1]})"
      ;;
    
    [fF] | [fF]"ight")
      echo "punch beats grab"
      echo "grab beats block"
      echo "block beats punch"
      ;;

    *)
      echo "Idon't understand $command"
      ;;
  esac

  echo ""

  if [[ ${position[0]} -eq ${door[0]} && ${position[1]} -ne ${door[1]} ]]; then
    if [[ ${position[1]} -lt ${door[1]} ]]; then 
      light north
    else
      light south
    fi
  fi

  if [[ ${position[0]} -ne ${door[0]} && ${position[1]} -eq ${door[1]} ]]; then
    if [[ ${position[0]} -lt ${door[0]} ]]; then 
      light east
    else
      light west
    fi
  fi


  if [[ ${position[0]} -eq ${treasure[0]} && ${position[1]} -eq ${treasure[1]} ]]; then
    echo "there is some treasure under your foot"
  fi


  if [[ ${position[0]} -eq ${NPC[0]} && ${position[1]} -eq ${NPC[1]}  ]]; then
    if [[ $bag == 2 || ${inventory[0]} == "scroll" ]]; then
      continue 
    fi

    echo "you caught me" | pv -qL 19 
    echo "you need the magic scroll to open" | pv -qL 19 
    echo "the doors to the underworld" | pv -qL 19 
    echo "if you give me the treasure I will" | pv -qL 19 
    echo "give it to you" | pv -qL 19 
    echo " \"g\" to give treasure"
    echo " \"f\" to fight for the scroll"
    echo " \"l\" to leave"
    read input
    
    case $input in
    [gG] | [gG]"ive")
      if [[ $bag == 1 ]]; then
        inventory=()
        inventory+=("scroll")
        ((bag++))
      fi
    ;;
    [fF] | [fF]"ight")
      _fight
      if [[ $wins == 1 ]]; then
        inventory+=("scroll")
        ((bag++))
      fi
    ;;
    *)
      echo "fine you will need this"
      echo "youl be back"
    ;;

    esac    
  fi

  echo "------------------------------------"
  
  if [[ ${position[0]} == ${door[0]} && ${position[1]} == ${door[1]} ]]; then
    echo "you have arived at the door"

    if [[ ${inventory[0]} == "scroll" || $bag == 2 ]]; then
      echo "you recite the incantation and your"
      echo "spirit crosses the threshold"

      leave=1
    else
      echo "you need an ancent scroll with a "
      echo "magic spell to open the door to "
      echo "the underworld"
    fi
  fi 

done


echo "--------------------------------------"
echo "  you escaped the underworld!!"
echo "  breath in the fresh air"
echo ""
echo "  you are free to live a normal life"
echo "  untill the reaper comes for you..." | pv -qL 4 
echo "--------------------------------------"
echo ""
echo ""
echo "             *********"
echo "           *************"
echo "          *****     *****"
echo "         ***           ***"
echo "        ***             ***"
echo "        **    0     0    **"
echo "        **               **                  ____"
echo "        ***             ***             //////////"
echo "        ****           ****        ///////////////  "
echo "        *****         *****    ///////////////////"
echo "        ******       ******/////////         |  |"
echo "      *********     ****//////               |  |"
echo "   *************   **/////*****              |  |"
echo "  *************** **///***********          *|  |*"
echo " ************************************    ****| <=>*"
echo "*********************************************|<===>* "
echo "*********************************************| <==>*"
echo "***************************** ***************| <=>*"
echo "******************************* *************|  |*"
echo "********************************** **********|  |*    "
echo "*********************************** *********|  |"
