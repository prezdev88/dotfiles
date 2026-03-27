#!/bin/bash

response=$(curl -s https://api.oilpriceapi.com/v1/demo/prices)
price=$(echo "$response" | jq -r '.data.prices[] | select(.code=="BRENT_CRUDE_USD") | .price')
change=$(echo "$response" | jq -r '.data.prices[] | select(.code=="BRENT_CRUDE_USD") | .change_24h')

if [ -n "$price" ]; then
    if [[ "$change" == -* ]]; then
        echo "%{F#4CAF50}󰏇%{F-} \$$price %{F#4CAF50}($change%)%{F-}"
    else
        echo "%{F#F44336}󰏇%{F-} \$$price %{F#F44336}(+$change%)%{F-}"
    fi
else
    echo "%{F#757575}󰏇%{F-} --"
fi
