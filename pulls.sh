page=1
pulls=0
H2=`cat public_repo_token`
curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" > out.json
while [ `cat out.json | jq '.[].user.login' | grep "" -c` -gt 0 ]
    do
    cat out.json | jq '.[]' | jq --arg nick "$1" 'select(.user.login==$nick)' >> userinfo.json
    pulls=$((pulls+`cat out.json | jq '.[]' | jq --arg nick "$1" 'select(.user.login==$nick) | .user.login' | grep "" -c`))
    page=$((page+=1))
    curl -s -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page={$page}" > out.json 
    done
timefirst=`cat userinfo.json | jq '.created_at' | sort | head -1 | sed 's/\"//g'`
merged_at=`cat userinfo.json | jq --arg timefirst "$timefirst" 'select(.created_at==$timefirst) | .merged_at'`
# echo $merged_at
if [ $merged_at = 'null' ]; then
    merged_at=0
else
    merged_at=1
fi
numberfirst=`cat userinfo.json | jq --arg timefirst "$timefirst" 'select(.created_at==$timefirst) | .number'`
printf "PULLS $pulls\n"
printf "EARLIEST $numberfirst\n"
printf "MERGED $merged_at\n"
rm -f userinfo.json
rm -f out.json
rm -f time.txt
