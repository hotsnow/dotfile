push_file_list="/usr/local/tools/initsys/initsys.sh"
remote_cmd="
    cd /tmp && sh initsys.sh
"
