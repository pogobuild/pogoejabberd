check_error()
{
  if [ $? -ne 0 ]; then
    echo "ERROR on >>>>> "$1"!!"
    exit 2
  fi
}

cd $WORKSPACE/pogotools/ejabberd-debmaker
if [ -e ejabberd-pkg.tar ];then
  rm -rf ejabberd-pkg.tar
fi

# no longer needed as platform no longer builds genius-app's
#$WORKSPACE/pogotools/ejabberd-debmaker/scripts/version_profiles.sh "debmaker/data/versions.tdd"

cd $WORKSPACE/pogotools/ejabberd-debmaker

tar zcvf ejabberd-pkg.tar * > /dev/null
#--exclude "gamebrick" --exclude "pogoweb" --exclude "psd" --exclude "srvbase" --exclude "userservice" --exclude ".p4config" --exclude "pom.xml" --exclude "setenv.bat" --exclude "settings.xml"


ssh $MSHIP 'rm -f /home/hudson/rm_*_tar'
check_error "SCP RM SCRIPTS"
scp $WORKSPACE/pogofacebook/debmaker/scripts/rm* $MSHIP:~
check_error "SCP - RM files"
ssh $MSHIP '/home/hudson/rm_deb_tar'
check_error "RM DEB TAR"
scp $WORKSPACE/pogofacebook/debmaker/debian-pkg.tar $MSHIP:~
check_error "SCP DEB TAR"
ssh $MSHIP "if [ ! -e /home/hudson/platform-repo/platform-work ]; then mkdir -p /home/hudson/platform-repo/platform-work; fi"
check_error "MKDIR - platform-work"
ssh $MSHIP 'tar -C /home/hudson/platform-repo/platform-work -xvf /home/hudson/debian-pkg.tar > /dev/null'
check_error "UNTAR"
ssh $MSHIP '/home/hudson/platform-repo/platform-work/scripts/change_file_perm.sh'
check_error "FILE PERM"
ssh $MSHIP '/home/hudson/platform-repo/platform-work/scripts/build_platform'
check_error "BUILD SCRIPT"
