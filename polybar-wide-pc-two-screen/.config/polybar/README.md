# Branches
- ```master```: PC polybar config file
- ```thinkpad```: Notebook polybar config file
- ```pc-one-screen```: PC one screen polybar config file

# Dependencies
- ```polybar```: main bar
- ```ttf-hack-nerd```: icons and glyphs used by the modules
- ```iproute2```: required by ```network_speed.sh``` for ```ip```
- ```curl```: required by ```weather.sh```
- ```redshift```: required by ```redshift.sh```
- ```lm_sensors```: required by ```cpu_temp``` module for ```sensors```
- ```pacman-contrib```: required by ```arch_updates.sh``` for ```checkupdates```
- ```yay```: required by ```aur_updates.sh```
- ```libnotify```: required by the weather module click action for ```notify-send```
- ```xfce4-terminal```: required by the update modules click actions
- ```pulseaudio``` or ```pipewire-pulse```: required for polybar pulseaudio module and ```current_sink.sh``` via ```pactl```

Optional / assumed:
- ```bash```, ```coreutils```, ```gawk```, ```grep```, ```sed```, ```procps-ng```: used by the scripts and usually present on Arch
- network access: required for the weather module

Install with yay:
```bash
yay -S polybar ttf-hack-nerd iproute2 curl redshift lm_sensors pacman-contrib yay libnotify xfce4-terminal pipewire-pulse
```
