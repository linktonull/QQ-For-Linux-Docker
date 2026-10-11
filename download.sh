#!/bin/bash
# https://aur.archlinux.org/cgit/aur.git/tree/download.sh?h=linuxqq-appimage&id=c5d02a88d502c53efe3c9a123d4c38c12b7518b1
# 
set -e
cookie=$(mktemp)
trap "rm -f ${cookie}" EXIT
qq_json=$(curl -s -o- https://qq-web.cdn-go.cn/im.qq.com_new/latest/rainbow/pcConfig.json)

url=$(jq -r '.Linux.x64DownloadUrl.deb' <<< "$qq_json")
version=$(jq -r '.Linux.version' <<< "$qq_json")
updateDate=$(jq -r '.Linux.updateDate' <<< "$qq_json")

date=$(echo "$updateDate" | tr -cd 'a-zA-Z0-9._-')
version=$(echo "$version" | tr -cd 'a-zA-Z0-9._-')
echo "QQ_VERSION=$version" >> "$GITHUB_ENV"
echo "QQ_DATE=$date" >> "$GITHUB_ENV"
echo "AUTO_TAG=${version}_${date}" >> "$GITHUB_ENV"

if [[ -z "$url" || "$url" == "null" ]]; then
    echo "Failed to extract download URL from QQ config."
    exit 1
fi

curl -sS -c "$cookie" "https://im.qq.com" >/dev/null
curl -L -o ./qq.deb $(curl -sS --json "{\"url\":\"${url}\"}" -b ${cookie} https://im.qq.com/http2rpc/gotrpc/noauth/trpc.qqntv2.urlsign.UrlSign/GetSign -H 'x-oidb: {"uint32_command":"0x9b8e","uint32_service_type":1}' | jq .data.url -r)