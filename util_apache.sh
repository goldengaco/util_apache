
#!/bin/bash
# Script : util_apache.sh
# Autor: Carlos Javier García Contreras

# mostrar usuarios actuales 

opcion=0
fechaActual=`date +%Y%m%d`
host=""
usuario=""

# Usuarios conectados actualmente
Info_usuario (){
    #read -s -p "Ingresar contraseña de sudo:" password
    echo -e "\n"
    echo -e " ### Usuarios conectados actualmente"
    w
    echo -e "\n"
    echo -e " ### muestra los ultimos 10 usuarios conectados"
    echo "$password" | sudo -S last | head
    echo -e "\n"
    echo -e " ### muestra las 10  conexiones fallidas por usuarios "
    echo "$password" | sudo -S lastb | head 
       read -n 1 -s -r -p "PRESIONE [ENTER] para continuar ..."
}


Intalar_apache (){
   verifyInstallapche=$(which apache2)
    if [ $? -eq 0 ] ; then  
         echo -e "\napache ya se encuentra en el equipo" 
    else 
            read -s -p "Ingresar contraseña de sudo:" password
            echo -e "\n"
            echo -e "Incio de instalación de apache"
            echo "$password" | sudo -S apt-get -y install apache2
            echo -e "Validar que este persistente apache"
            echo "$password" | sudo -S systemctl is-enabled apache2
            if [ $? -eq 0 ] ; then 
                echo "ya esta persistente"
            else
            echo "$password" | sudo -S systemctl enabled apache2
            fi
            echo -e "Inicia el servicio de apache"
            echo "$password" | sudo -S service apache2 start
            echo -e "Muestra estatus de apache"
            echo "$password" | sudo -S service apache2 status 
    fi 
    read -n 1 -s -r -p "PRESIONE [ENTER] para continuar ..."
}


Desintalar_apache (){
    echo "Desintalar apache"
    read -s -p "Ingresar contraseña de sudo:" password
    echo "$password" | sudo -S apt-get -y  remove apache2.*
    
       read -n 1 -s -r -p "PRESIONE [ENTER] para continuar ..."
}


pasar_archivo_log (){
    echo "Se pasaran archivos log del servicio apache"
    echo -e "\n"
    read -s -p "Ingresar contraseña de sudo:" password
    echo -e "\n"
    read -p "Ingresar el host:" host
    echo -e "\n"
    read -p "Ingresar el usuario:" usuario
    echo -e "\nEn esste momento se procederá a comprimir los archivos log con contraseña "
    zip -e /tmp/log_apache_$fechaActual.zip /var/log/apache2/*.log    
    echo -e "\n"
    read -p "Ingresar la ruta destino:" ruta_destino
    rsync -avz /tmp/log_apache_$fechaActual.zip   $usuario@$host:$ruta_destino
    read -n 1 -s -r -p "PRESIONE [ENTER] para continuar ..."
}



while :
do  
    # Limpiar la pantalla
    clear
    # Desplegar el menú de opciones
    echo "------------------------------------------"
    echo "     util_apache.sh - Utileria apache     "
    echo "------------------------------------------"
    echo "             MENU PRINCIPAL               "
    echo "------------------------------------------"
    echo "1. Información  de usuario "
    echo "2. Instalación de apache"
    echo "3. Desintalar apache"
    echo "4. Pasar archivos log de apache2"
    echo "5. Salir"
    echo "------------------------------------------"
    # Leer los datos del usuario - capturar información
    read -n1 -p "Ingrese una opción [1-5]:" opcion
    echo -e "\n"

    #validar la opción Ingresada
    case $opcion in 
        1)
            Info_usuario
             sleep 2
            ;;
        2) 
            Intalar_apache
            sleep 2
            ;;
        3) 
            Desintalar_apache
            sleep 2 
            ;;
        4)  
            pasar_archivo_log
            sleep 2
            ;;
        5) 
            echo  -e "\nSalir del Programa"
            exit 0 
            ;;
     esac
done      

