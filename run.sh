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
    # remove_lockfile
    flow_cmd "pod install --no-repo-update"    
    source /usr/local/bin/unproxy.sh
fi

