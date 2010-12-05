version_file="$WORKSPACE/pogofacebook/pogoweb/src/main/webapp/version.txt"

check_error()
{
  if [ $? -ne 0 ]; then
    echo "ERROR on >>>>> "$1"!!"
    exit 2
  fi
}

$WORKSPACE/pogofacebook/debmaker/scripts/version_profiles.sh
check_error "VERSIONING PROFILE"

chmod 644 $version_file
echo "version: $P4_CHANGELIST" > $version_file
echo "time: " `date` >> $version_file
echo >> $version_file
echo "build info: $BUILD_URL" >> $version_file

sed -i "s/build.number=.*$/build.number=$P4_CHANGELIST/" $WORKSPACE/pogofacebook/debmaker/packages/genius-app-conf/home/j2play/config.templates/genius-app-conf/app.properties.ftl
check_error "SED-build_num"
