#!/usr/bin/env bash

#set -x

cd $(pwd -P) || exit 1

action=$1
shift

sub_usage() {
    echo "./$0 create"
    echo "./$0 [review|approve] PRID"
}

if [[ -z $action ]]; then
    sub_usage
    exit 1
fi

project=$(git config --get remote.origin.url |awk -F'/' '{print $(NF-2)}')
# network/chatops ...
repository=$(git config --get remote.origin.url |awk -F'/' '{print $NF}')
domain=$(git config --get remote.origin.url |awk -F'[/.@]' '{print $3}')
# master/dev ...
branch=$(git rev-parse --abbrev-ref HEAD)

[[ -z $domain ]] && {
    echo "not running in git directory"
    exit 1
}

vsts configure --defaults instance=https://${domain}.visualstudio.com

# check login status
if vsts code pr list 2>&1 |grep -q 'setup credentials'; then
    token=$(security find-internet-password -w -a weiwlai -s ${domain}.visualstudio.com)
    [[ -z $token ]] && exit 1
    vsts login --instance https://${domain}.visualstudio.com/ --token $token || exit 1

    #token=$(security find-internet-password -w -a xxxx -s dev.azure.com)
    #[[ -z $token ]] && exit 1
    #vsts login --instance https://dev.azure.com/xxxx --token $token || exit 1
    #vsts configure --defaults instance=https://dev.azure.com/xxxx
fi

if [[ $action == update ]]; then
    # need to check project to add FbCoreOps
    url_list=$(vsts code repo list --project $project |jq '.[].remoteUrl' |tr -d '"')
    for url in $url_list; do
        [[ -z $url ]] && continue
        repository=$(echo "$url" |awk -F'/' '{print $NF}')
        echo "$url"
        if [[ ! -d "$HOME/FB/${project}/$repository" ]]; then
            cd $HOME/FB/${project}/ && git clone $url
        else
            cd $HOME/FB/${project}/$repository && git checkout -q master  && git pull
            if git branch -a |grep -wq 'origin/master'; then
                git checkout -q master  && git pull
            else
                git checkout -q main  && git pull
            fi
        fi
    done
# create a pr on the current location
elif [[ $action == create ]]; then
    if [[ -z $repository || -z $branch || $branch == master ]]; then
        exit 1
    fi

    echo "Title for the PR:"
    read title
    if [[ -z $title ]]; then
        commit_info=$(git log --format=%B -n 1)
        if [[ $(echo -e "$commit_info" |grep -c '[a-zA-Z]') == 1 ]]; then
            title=$commit_info
            desc=$commit_info
        else
            title=$(echo -e "$commit_info" |head -n 1)
            desc=$(echo -e "$commit_info" |tail -n +3)
        fi
    else
        echo "Description for the PR:"
        read desc
    fi

    pr_info=$(vsts code pr create \
                --title "$title" \
                --description "$desc" \
                --repository $repository)
        #--source-branch $branch \
        #--delete-source-branch \
        #--auto-complete \

    prid=$(echo "$pr_info" |jq .url |awk -F'/' '{print $NF}' |tr -d '"')

    if [[ -n $prid ]]; then
        echo https://${domain}.visualstudio.com/${project}/_git/${repository}/pullrequest/$prid |tee /dev/tty |pbcopy
    else
        echo "$pr_info" |tee /dev/tty |pbcopy
    fi

    exit 0
else
    prid=$1
    if [[ -z $prid ]]; then
        sub_usage
        exit 1
    fi

    if [[ $action == review ]]; then
        # get repository name and source branch
        info=($(vsts code pr show --id $prid |jq '.repository.remoteUrl, .sourceRefName' |tr -d '"'))

        # pull latest change
        dir=$(echo ${info[0]} |awk -F'/' '{print $(NF-2),$NF}')
        cd ~/FB/${dir/ /\/} && git checkout && git pull || exit 1

        # diff it with master
        git diff ..remotes/origin/${info[1]/refs\/heads\/}
    else
        vsts code pr set-vote approve --id $prid
    fi
fi

