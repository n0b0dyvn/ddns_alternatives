#requirement

which apt-file > /dev/null || (sudo apt-get install apt-file -y && sudo apt-file update > /dev/null)

REQUIRE=( dig curl /sbin/ifconfig jq)

for rq in "${REQUIRE[@]}" ;  do
	which $rq > /dev/null || sudo apt-get install -y $(apt-file find --regex "/$rq$" | head -n1 | awk -F: '{print $1}') 
	# I only get first one, if it failed, you may want to fix it manually
done

#I just get ip from eth0, if you have another interface, define it
LAN_Interface=eth0
LAN_IP=$(/sbin/ifconfig $LAN_Interface | grep -Po "inet addr:[0-9.]* " | grep -Po "[0-9.]*") 

export PUB_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"

DOMAIN=sangvo.tk
API_CF=<YOUR GLOBAL API KEY>
EMAIL_CF=<YOUR LOGIN EMAIL>
API_URL=https://api.cloudflare.com/client/v4

ZONE=$(curl -X GET "$API_URL/zones?name=$DOMAIN&status=active&page=1&per_page=1&order=status&direction=desc&match=all" \
     -H "X-Auth-Email: $EMAIL_CF" \
     -H "X-Auth-Key: $API_CF" \
     -H "Content-Type: application/json" \
	2> /dev/null | jq ".result[0].id" | tr -d '"')

export SUB="pub"

SUB_ID=$(curl -X GET "$API_URL/zones/$ZONE/dns_records?name=$SUB.$DOMAIN&match=all" \
     -H "X-Auth-Email: $EMAIL_CF" \
     -H "X-Auth-Key: $API_CF" \
     -H "Content-Type: application/json" | jq ".result[0].id" | tr -d '"')

curl -X PUT "$API_URL/zones/$ZONE/dns_records/$SUB_ID" \
     -H "X-Auth-Email: $EMAIL_CF" \
     -H "X-Auth-Key: $API_CF" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"A\",\"name\": \"$SUB\" ,\"content\": \"$PUB_IP\" }"
