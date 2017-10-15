#!/data/data/com.termux/files/usr/bin/bash
# Copyright 2017 (c) all rights reserved
# by SDRausty https://sdrausty.github.io/termux-arch
# modified by Gwenhael Le Moine https://github.com/gwenhael-le-moine/TermuxSlack
echo "This setup script will attempt to set Slackware Linux up in your Termux environment."
echo
sleep 4
echo "It  will generate many error messages \"tar: Ignoring unknown extended header keyword 'SCHILY.fflags'\" && one \"tar: Exiting with failure status due to previous errors\" message."
sleep 3
echo
echo "Ignore these messages, and please wait patiently as tar decompresses the download once completed."
echo
sleep 2
echo "When successfully completed, you will be at the bash prompt in Slackware Linux in Termux."
sleep 1
pkg up
pkg install proot tar
echo
mkdir -p $HOME/slackware
cd $HOME/slackware
echo "Downloading slackware-image."
echo
if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "armv7l" ];then
    wget -c ftp://ftp.arm.slackware.com/slackwarearm/slackwarearm-devtools/minirootfs/roots/slack-current-miniroot_11Oct17.tar.xz -O slackware.tar.xz
else
    echo "Unknown architecture version for this setup script! There is hope."
    echo "Please check for other available architectures at http://mirror.archlinuxarm.org/os/"
    exit 1
fi
echo "While decompressing the slackware image tar will probably echo, "tar: Ignoring unknown extended header keyword 'SCHILY.fflags'" && "tar: Exiting with failure status due to previous errors""
sleep 2
echo "Please ignore these messages and wait patiently as tar decompresses the download."
sleep 2
proot --link2symlink tar -xf slackware.tar.xz||:
bin=startSlackware
echo "Writing launch script."
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
proot --link2symlink -0 -r ~/slackware -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@slackware \W]\$ ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
EOM
echo "Making $bin executable."
chmod 700 $bin
echo "Launch Slackware Linux in Termux with ./slackware/$bin"
$HOME/slackware/$bin
