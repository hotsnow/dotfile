push_file_list="/usr/local/tools/initsys/vaskey_cld_release_bu_oss_V3.tar"
remote_cmd="
    [ -d \"/home/oicq\" ] || {
        tar xf /tmp/vaskey_cld_release_bu_oss_V3.tar -C /tmp;
        cd /tmp/vaskey_release && bash install_vaskey_cld.sh;
        sleep 5
    }
    for i in {1..10}; do
        /home/oicq/vas_key/config_center_V2/check_myself |grep 'Goo[d]' && {
            vask_flag=ok
            break
        }
        sleep 5
    done
    [[ \"\$vask_flag\" == 'ok' ]] || { echo 'FAIL_FLAG vask install failed'; exit 1; }
"
log_file=log/vaskey_install_`date +%Y%m%d%H%M%S`.log
