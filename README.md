Este script es una intención de automatizar el proceso de creación de jaulas dentro de archivos .img
Primero se selecciona el sistema operativo, de momento están disponibles las lts de ubuntu y las 3 versiones de debian usadas en este momento
Debian 10,11,12 proximamente meteré las diferentes versiones hacia atrás de debian y las no lts de Ubuntu
Después se selecciona el tamaño de la imagen, 4,8,16 y 32 Gb, posiblemente añada opciones mas pequeñas y mas grandes

El procedimiento de script es el siguiente
Selecciona parametros OS y tamaño
Crear y formatear la imagen
Crear un script dentro del script llamado config.sh ,éste script secundario es para configurar el contenedor de forma interna, estós son los parametros:
-Finalización de debootstrap
-locales
-Actualización de sistema

Por ultimo se sale del chroot y se desmontan los directorios.
