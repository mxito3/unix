#! /bin/bash

echo -e "  Linux library Manager \nthis is a linux application \npress any key to continue"
read
echo -e "Linux Library Main-Menu\n0 : exit the program \n1 : edit the menu \n2 : report menu"
read mainInput
echo "input is $mainInput"
breakControl=0 #设置跳出条件
if [ $mainInput -eq 1 ] ##编辑菜单
then
    clear
    echo "in 1"
    while true
    do
        echo -e "Linux library - Edit Menu \n 0 : return to the main menu \n 1 : ADD books \n 2 : Update status \n 3 : Dispaly \n 4 : Edit "
        inputTemp=''   #用来存放输入的结构体
        title=''
        author=''
        choose=1
        while true
        do 
            if [ $breakControl -eq 1 ]
             then
                breakControl=0
                break
            fi
            continueChoose='y'
            echo "please input choose"
            read choose 
                case $choose in
                #增加模式
                1)
                    echo -e "Add mode \n "
                    while true
                    do
                        echo "Author:"
                        read author
                        echo "Title :"
                        read title
                        booknow=$(cat library |wc -l)
                        bookid=`expr $booknow + 1`
                        inputTemp="$bookid $author $title in"
                        echo "$inputTemp">> library
                        echo "any more to add? (y for yes,n for no)"
                        read continueChoose 
                        case $continueChoose in 
                            y)
                                continue
                                ;;
                            n)
                                clear
                                breakControl=1
                                break
                                ;;
                        esac;
                    done
            ;;
                2)#更新状态
                    echo -e "Update mode \nplease input author : "
                    read searchName
                    all=($(cat library|grep ^$searchName))
                    #取出每一行的序号
                    for each in ${all[*]}
                    do
                        echo $each
                    done
                    

                    ;;
                esac;

        done
    done
elif [ $mainInput == 0 ]
then
    echo "in 0"
    exit
elif [ $mainInput == 2 ] #导出书籍
then
    echo "in export"
else
    echo "in others"
    echo "wrong input"
fi 
