#!/bin/bash

libdata="ULIB_FILE"
tempfile=tempfile$$
if [ ! -f $libdata ] ; then
touch $libdata
chmod 744 $libdata
fi
touch $tempfile

# return 1 for yes, 0 for no
yes_or_no() {
  while true; do
    read yesOrNo;
    case "$yesOrNo" in
      "Y" | "y" | "YES" | "Yes" | "yes") return 1;;
      "N" | "n" | "NO" | "No" | "no") return 0;;
      *) printf "\n(\033[1mY\033[0m)es or (\033[1mN\033[0m)o\n";;
    esac
  done;
}

set_return() {
  return $1
}

introduction() {
  clear
    echo -e  "\t\033[1mLinux Library Manager\033[0m\n" 
    echo "This is the linux library application" 
    printf "Please enter any key to continue..."
    read any_key
}

edit_add() {
  set_return 1
  until test $? -eq 0; do
    clear
    printf "\tLinux library - \033[1mADD MODE\033[0m\n\n"
    read -p "Title:    " title
    read -p "Author:   " author
    valid_input=0
    until test $valid_input -eq 1; do
      read -p "Category: " category
      case $category in
        "sys" | "ref" | "tb") valid_input=1;;
        *)                    echo "sys: system  ref: reference  tb: textbook"
      esac
    done
    echo "${title}:${author}:${category}:in:--:--" >> $libdata
    printf "Any more to add? (Y)es or (N)o >"
    yes_or_no
  done;
}

edit_update() {
  set_return 1
  until test $? -eq 0; do
    clear
    printf "\tLinux library - \033[1mUPDATE MODE\033[0m\n\n"
    read -p "Enter the author/title >" input

    awk -F: -v book="$input"       \
        '$1 ~ book || $2 ~ book    { printf("\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n\n", "Title: ", $1, "Author: ", $2, "Category: ",$3, "Status: ", $4); };            \
        ' $libdata > $tempfile
    if test -z $tempfile; then
      printf "\nNo book found\n"
    else
      cat $tempfile
      printf "\n\tUpdate these books? >"
      yes_or_no
      if test $? -eq "1"; then
        time=`date`
        read -p "Enter borrower's name:" bowrrower
        read -p "Enter checker's name:" checker
        
        awk -F: -v book="$input" -v time="$time"  -v checker="$checker"   \
        '$1 ~ book || $2 ~ book    {  if ($4 == "in") { new4 = "out" } else { new4 = "in"; } printf("\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n\n", "Title: ", $1, "Author: ", $2, "Category: ",$3, "Status: ", $4, "date: ", time, "Checked out by: ", checker, "New status: ", new4); };            \
          ' $libdata 
        awk -F: -v book="$input" -v bowrrower="$bowrrower" -v time="$time"     \
          ' $1 ~ book || $2 ~ book    { if ($4 == "in") { $4 = "out"  } else { $4 = "in" ; bowrrower = "--"; time = "--" }  printf("%s:%s:%s:%s:%s:%s\n", $1,$2,$3,$4,bowrrower,time) } ;   \
            $1 !~ book && $2 !~ book { print }  \
          ' $libdata > $tempfile
        mv $tempfile $libdata
      fi
    fi
    printf "Any more to update? (Y)es or (N)o >"
    yes_or_no
  done;
}
   
  
display() {
    awk -F:         \
        '       { printf("%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n\n", "Title: ", $1, "Author: ", $2, "Category: ",$3, "Status: ", $4); };            \
        '
}

edit_display() {
  set_return 1
  until test $? -eq 0; do
    clear
    printf "Enter the author/title >"
    read input
    printf "\tLinux library - \033[1mDISPLAY MODE\033[0m\n"

    awk -F: -v book="$input"      \
        ' $1 ~ book || $2 ~ book    { printf("\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n\n", "Title: ", $1, "Author: ", $2, "Category: ",$3, "Status: ", $4); };            \
        ' $libdata  > $tempfile
    if test ! -s $tempfile; then
      printf "\nNo book found\n"
    else  
      cat $tempfile
    fi
    printf "Any more to display? (Y)es or (N)o >"
    yes_or_no
  done;
}

edit_delete() {
  set_return 1
  until test $? -eq 0; do
    clear
    printf "Enter the author/title >"
    read input
    printf "\tLinux library - \033[1mDELETE MODE\033[0m\n"

    awk -F: -v book="$input"      \
        ' $1 ~ book || $2 ~ book    { printf("\n%15s%-15s\n%15s%-15s\n%15s%-15s\n%15s%-15s\n\n", "Title: ", $1, "Author: ", $2, "Category: ",$3, "Status: ", $4); };            \
        ' $libdata > $tempfile
    if test ! -s $tempfile; then
      printf "\nNo book found\n"
    else  
      cat $tempfile
      printf "\n\tDelete these books? >"
      yes_or_no
      if test $? -eq 1; then
        awk -F: -v book="$input"      \
            ' $1 !~ book && $2 !~ book    { print }    \
            ' $libdata > $tempfile
        mv $tempfile $libdata
      fi
    fi
    printf "Any more to delete? (Y)es or (N)o >"
    yes_or_no
  done;
}
   

lib_edit() {
  while true; do
    clear
    echo -e "Linux Library - \033[1mEdit Menu\033[0m" 
    echo -e "0:  \033[1mRETURN\033[0m to the main menu"
    echo -e "1:  \033[1mADD\033[0m"
    echo -e "2:  \033[1mUPDATE\033[0m STATUS"
    echo -e "3:  \033[1mDISPLAY\033[0m"
    echo -e "4:  \033[1mDELETE\033[0m"
    echo
    read -p "Enter your choice >" input
    case $input in
      0)
        return 0;;
      1)
        edit_add;;
      2) 
        edit_update;;
      3) 
        edit_display;;
      4) 
        edit_delete;;
      *) 
      read -p "Wrong Input. Try agin >" input;;
    esac
  done
}

lib_report() {
while true; do
  clear
  echo -e "Linux Library - \033[1mREPORTS Menu\033[0m" 
  echo -e "0: \033[1mreturn\033[0m"
  echo -e "1: sorted by \033[1mTITLES\033[0m"
  echo -e "2: sorted by \033[1mAUTHOR\033[0m" 
  echo -e "3: sorted by \033[1mCATEGORY\033[0m"
  echo
  read -p "Enter your choice >" input
  case $input in
    0)
    return 0;;
    1)
    sort -t ":" -k1 $libdata | display
    read any_key;;
    2) 
    sort -t ":" -k2 $libdata | display
    read any_key;;
    3) 
    sort -t ":" -k3 $libdata | display
    read any_key;;
    *) 
      valid_input="no"
      read -p "Wrong Input. Try agin >" input;;
  esac
done
}

# the main control flow

introduction
while true; do
  clear
  echo -e "Linux Library - \033[1mMain Menu\033[0m" 
  echo -e "0:  \033[1mEXIT\033[0m the program" 
  echo -e "1:  \033[1mEDIT\033[0m the menu" 
  echo -e "2:  \033[1mREPORT\033[0m menu" 
  echo
  read -p "Enter your choice >" input
  case $input in
    0)
    if test -f $tempfile; then
      rm $tempfile
    fi
    exit 0;;
    1)
    lib_edit;;
    2) 
    lib_report;;
    *) 
    read -p "Wrong Input. Try agin >" input;;
  esac
done

