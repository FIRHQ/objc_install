cd $FLOW_CURRENT_PROJECT_PATH

remove_lockfile() {
  podfile_lock=($(find ./ -maxdepth 1 -name "Podfile.lock"))
  if [ -n $podfile_lock ]; then
    mv $podfile_lock Podfile.bk.lock
  fi
}

if [ -f Podfile ];then
    cp Podfile Podfile.bak
    sed -i -e 's/^[[:space:]]*source/#source/g' Podfile
    source /usr/local/bin/proxy.sh
    # export https_proxy=$http_proxy
#    remove_lockfile
    flow_cmd "pod install --no-repo-update"    
    source /usr/local/bin/unproxy.sh
fi
tar -zcf Pods.tar.gz Pods

ftp -n -i >> ftp.log <<EOF
open 172.16.152.110
user flow flow.ci
cd flow
mkdir ${FLOW_USER_ID}
mkdir ${FLOW_USER_ID}/${FLOW_PROJECT_ID}
put Pods.tar.gz ${FLOW_USER_ID}/${FLOW_PROJECT_ID}/Pods.tar.gz
bye
EOF
