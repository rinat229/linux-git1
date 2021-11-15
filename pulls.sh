page=1
pulls=0
H2=`cat public_repo_token`
userinfo=""
timefirst=`curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[]' | jq --arg nick "$1" 'select(.user.login==$nick) | .created_at' | sort | head -1 | sed 's/\"//g'`
prevtimefirst=$timefirst
numberfirst=0
merged_at=0
while [ `curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[].user.login' | grep "" -c` -gt 0 ]
    do
    pulls=$((pulls+`curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[]' | jq --arg nick "$1" 'select(.user.login==$nick) | .user.login' | grep "" -c`))
    current=`curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[]' | jq --arg nick "$1" 'select(.user.login==$nick) | .created_at' | sort | head -1 | sed 's/\"//g'`
    if [[ ! -z $current ]]; then
        timefirst=$current
    fi
    prevtimefirst=$timefirst
    if [[ (( "$timefirst" < "$prevtimefirst" || "$timefirst" = "$prevtimefirst" )) &&  ! -z $current ]]; then
        merged_at=`curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[]' | jq --arg timefirst "$timefirst" 'select(.created_at==$timefirst) | .merged_at'`
        numberfirst=`curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" | jq '.[]' | jq --arg timefirst "$timefirst" 'select(.created_at==$timefirst) | .number'`
    elif [[ ! -z "$prevtimefirst" ]]; then
        timefirst=$prevtimefirst
    fi
    page=$((page+=1))
    done
if [[ $merged_at = 'null' ]]; then
    merged_at=0
else
    merged_at=1
fi
printf "PULLS $pulls\n"
printf "EARLIEST $numberfirst\n"
printf "MERGED $merged_at\n"

