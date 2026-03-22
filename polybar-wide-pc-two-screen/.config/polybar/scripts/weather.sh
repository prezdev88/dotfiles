#!/bin/bash

response="$(curl -4fsS 'https://api.open-meteo.com/v1/forecast?latitude=-35.4264&longitude=-71.6554&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code&timezone=America%2FSantiago' 2>/dev/null)"

temperature="$(printf '%s' "$response" | sed -n 's/.*"temperature_2m":\([-0-9.]*\).*/\1/p')"
apparent_temperature="$(printf '%s' "$response" | sed -n 's/.*"apparent_temperature":\([-0-9.]*\).*/\1/p')"
humidity="$(printf '%s' "$response" | sed -n 's/.*"relative_humidity_2m":\([0-9]*\).*/\1/p')"
wind_speed="$(printf '%s' "$response" | sed -n 's/.*"wind_speed_10m":\([-0-9.]*\).*/\1/p')"
weather_code="$(printf '%s' "$response" | sed -n 's/.*"weather_code":\([0-9]*\).*/\1/p')"

case "$weather_code" in
  0) icon="󰖙"; condition="Despejado" ;;
  1|2) icon="󰖕"; condition="Poco nuboso" ;;
  3) icon="󰖐"; condition="Nublado" ;;
  45|48) icon="󰖑"; condition="Niebla" ;;
  51|53|55|56|57) icon="󰖖"; condition="Llovizna" ;;
  61|63|65|66|67|80|81|82) icon="󰖗"; condition="Lluvia" ;;
  71|73|75|77|85|86) icon="󰼶"; condition="Nieve" ;;
  95|96|99) icon="󰖓"; condition="Tormenta" ;;
  *) icon="󰖐"; condition="Variable" ;;
esac

if [ "$1" = "--details" ]; then
  if [ -n "$temperature" ]; then
    printf "Talca\n"
    printf "%s  %s\n" "$icon" "$condition"
    printf "󰔄 %s°C\n" "$temperature"
    printf "󰃚 %s°C\n" "$apparent_temperature"
    printf "󰖌 %s%%\n" "$humidity"
    printf "󰖝 %s km/h\n" "$wind_speed"
  else
    printf "Clima no disponible\n"
  fi
  exit 0
fi

if [ -n "$temperature" ]; then
  printf "%%{F#4FC3F7}%s%%{F-} %s°C %s\n" "$icon" "$temperature" "$condition"
else
  printf "%%{F#4FC3F7}󰖙%%{F-} --\n"
fi
