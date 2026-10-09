#!/bin/bash

show_error() {
    echo "%{F#F44336}󰏇 --%{F-}"
}

response=$(curl --fail --silent --show-error --connect-timeout 5 --max-time 10 \
    https://api.oilpriceapi.com/v1/demo/prices 2>/dev/null) || {
    show_error
    exit 0
}

price=$(jq --exit-status --raw-output \
    '.data.prices[]? | select(.code == "BRENT_CRUDE_USD") | .price' \
    <<< "$response" 2>/dev/null) || {
    show_error
    exit 0
}

change=$(jq --exit-status --raw-output \
    '.data.prices[]? | select(.code == "BRENT_CRUDE_USD") | .change_24h' \
    <<< "$response" 2>/dev/null) || {
    show_error
    exit 0
}

if [[ "$change" == -* ]]; then
    echo "%{F#4CAF50}󰏇%{F-} \$$price %{F#4CAF50}($change%)%{F-}"
else
    echo "%{F#F44336}󰏇%{F-} \$$price %{F#F44336}(+$change%)%{F-}"
fi
