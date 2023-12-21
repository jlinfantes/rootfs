#!/bin/sh
clear
os_debian(){
clear
echo "Debian"
echo "1. Debian 10 Buster"
echo "2. Debian 11 Bullseye"
echo "3. Debian 12 bookworm"
echo "4. Atras"
echo "5. salir"
echo -n " Selecciona una opción [1-5]"
read debian
case $debian in
	1) imagen=buster;;
	2) imagen=bullseye;;
	3) imagen=bookworm;;
	4) os_seleccion;;
	5) exit;;
	*) echo "Opcion no valida";;
esac
}
os_ubuntu() {
clear
echo "Ubuntu "
echo "1. Trusty"
echo "2. Xenial"
echo "3. Bionic"
echo "4. Focal"
echo "5. Jammy"
echo "6. Atras"
echo "7. Salir"
echo -n " Selecciona una opción [1-7]"
read ubuntu
case $ubuntu in
        1) imagen=trusty;;
        2) imagen=xenial;;
        3) imagen=bionic;;
        4) imagen=focal;;
        5) imagen=jammy;;
	6) os_seleccion;;
        7) exit;;
	*) echo "Opcion no valida";;
esac
}
os_seleccion() {
clear
echo "Selecciona Sistema operativo"
echo "1. Ubuntu"
echo "2. Debian"
echo "3. Salir"
echo -n " Selecciona una opción [1-3]"
read OS
case $OS in
	1) os_ubuntu;;
	2) os_debian;;
	3) exit;;
	*) echo "Opcion no valida";;
esac
}
disco_tamano() {
clear
echo "Tamaño del disco"
echo "1. 4Gb"
echo "2. 8Gb"
echo "3. 16Gb"
echo "4. 32Gb"
read disk
case $disk in
1) disco=4096M;;
2) disco=8192M;;
3) disco=16000M;;
4) disco=32000M;;
*) echo "Incorrecto"
esac
}
os_seleccion
disco_tamano

apt install debootstrap -y
mkdir /$imagen
dd if=/dev/zero of=$imagen.img bs=1 count=0 seek=$disco
mkfs.ext4 $imagen.img
chmod 777 $imagen.img
mount -o loop $imagen.img /$imagen
debootstrap  --foreign $imagen /$imagen

sudo mount -o bind /dev /$imagen/dev
sudo mount -o bind /dev/pts /$imagen/dev/pts
sudo mount -t sysfs /sys /$imagen/sys
sudo mount -t proc /proc /$imagen/proc
> config.sh
cat <<+ >> config.sh
#!/bin/sh
echo " Configurando debootstrap segunda fase"
sleep 3
/debootstrap/debootstrap --second-stage
export LANG=
repo_trusty
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "Europe/Berlin" > /etc/timezone
echo "$imagen" >> /etc/hostname
echo "127.0.0.1 $imagen localhost
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" >> /etc/hosts
echo "auto lo
iface lo inet loopback" >> /etc/network/interfaces
echo "/dev/mmcblk0p1 /	   ext4	    errors=remount-ro,noatime,nodiratime 0 1" >> /etc/fstab
echo "tmpfs    /tmp        tmpfs    nodev,nosuid,mode=1777 0 0" >> /etc/fstab
echo "tmpfs    /var/tmp    tmpfs    defaults    0 0" >> /etc/fstab	
apt-get update
echo "Reconfigurando parametros locales"
locale-gen es_ES.UTF-8
export LC_ALL="es_ES.UTF-8"
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
dpkg-reconfigure -f noninteractive tzdata
apt-get upgrade -y 
hostnamectl set-hostname bionic
sudo apt install ubuntu-minimal  -y
apt-get -f install
apt-get clean
adduser $imagen
addgroup $imagen sudo
addgroup $imagen adm
addgroup $imagen users
+
chmod +x  config.sh
sudo cp  config.sh /$imagen/home
chroot /$imagen /bin/sh -i ./home/config.sh
rm config.sh
exit