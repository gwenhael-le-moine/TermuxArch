#!/data/data/com.termux/files/usr/bin/bash
# Copyright 2017 (c) all rights reserved
# by SDRausty https://sdrausty.github.io/termux-arch
# modified by Gwenhael Le Moine https://github.com/gwenhael-le-moine/TermuxSlack

echo "This setup script will attempt to set Slackware Linux up in your Termux environment."
echo
echo "When successfully completed, you will be at the bash prompt in Slackware Linux in Termux."

pkg up
pkg install proot tar wget curl

mkdir -p $HOME/slackware
cd $HOME/slackware

echo "Downloading slackware-image."
echo
if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "armv7l" ];then
    wget -c ftp://ftp.arm.slackware.com/slackwarearm/slackwarearm-devtools/minirootfs/roots/slack-current-miniroot_25Nov19.tar.xz -O slackware.tar.xz
else
    echo "Unknown architecture version for this setup script! There is hope."
    echo "Please check for other available architectures at http://mirror.archlinuxarm.org/os/"
    exit 1
fi
bin=startSlackware
echo "Writing launch script."
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
proot --link2symlink -0 -r ~/slackware -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@slackware \W]\$ ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
EOM

echo "Making $bin executable."
chmod 700 $bin

echo "Launch Slackware Linux in Termux with ./slackware/$bin"
$HOME/slackware/$bin
