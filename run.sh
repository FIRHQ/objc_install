cd $FLOW_CURRENT_PROJECT_PATH

if [ -f Podfile ];then
    cp Podfile Podfile.bak
    sed -i -e 's/^[[:space:]]*source/#source/g' Podfile
    export http_proxy=http://172.16.152.110:8123
    export https_proxy=$http_proxy
    flow_cmd "pod install --no-repo-update"
    unset http_proxy
    unset https_proxy
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
