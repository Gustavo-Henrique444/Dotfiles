#
# ~/.bashrc
#

# If not running interactively, don't do anything
fastfetch

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '



eval "$(starship init bash)"

function reboot() {
	sudo systemctl reboot
}

configBackup(){
	cd /home/luno/Backup/config/
 echo -e $"\e[1;32m📁 Wait Pulling ./Config..." | pv -qL 32
 rsync -avh --progress ~/.config/ /home/luno/Backup/config/

}

gitpush() {
  if [ -z "$1" ]; then
    echo "❌ Você precisa passar uma mensagem de commit."
    echo "Uso: gitpush \"mensagem do commit\""
    return 1
  fi

  git add .
  git commit -m "$1"

	

echo -e $"\e[1;32m🚀 Pushing to remote..." | pv -qL 32

  if git push; then
	  echo -e $"\e[1;32m✅ Push successful!" | pv -qL 32
    else
        echo -e $"\e[1;32m Push failed – attempting to rebase and try again..." | pv -qL 32
        git pull --rebase

        echo -e $"\e[1;32m🔁 Retrying push..." | pv -qL 32
        if git push; then
            echo -e $"\e[1;32m✅ Push successful after rebase!" | pv -qL 32
        else
            echo -e $"\e[1;32m❌ Push failed again. Please check manually." | pv -qL 32
        fi
    fi
}

source() {
  command source
  cp ~/.bashrc /home/luno/Backup/config/bashrc
  clear
  echo -e $"\e[1;32mCopiado com sucesso 📒" | pv -qL 32
}

function update() {
	echo -e $"\e[1;32m🕒 Starting Update This May Take A While..." | pv -qL 32
	sudo reflector --country Brazil --latest 19 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Syu --noconfirm
	yay -Syu --noconfirm
	sudo pacman -Sc --noconfirm
	yay -Sc --noconfirm
	yay -Yc --noconfirm
	rm -rf .cache/* --noconfirm 
	clear
	echo -e $"\e[1;32m🔒 Everything is Up to Date, Have a Good Day Luno!!" | pv -qL 32
}

function static() {
	echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save
	echo "Static Gone!!"
}

function mensagem () {
mensagens=(
    "👁️ Neural link forged deep within the simulated Matrix."
    "🌌 System purged. Mind sharpened to lethal edge."
    "🚀 Quantum jump engaged—breaking every boundary."
    "🔮 Shell unlocked. Cryptic power unleashed, unstoppable."
    "🐧 Arch ignited, running wild in the cyber abyss."
    "💀 root commands the mainframe—fear is obsolete."
    "🕶️ clear() — scrubbing logs, leaving no trace in neon shadows."
    "🧬 Code bleeds, alive in the veins of the network."
    "🌀 Digital void rips open your fractured reality."
    "⚡ Ghost in the machine, hunting through the wires."
    "🔗 Chains broken—freedom coded in zeros and ones."
    "☠️ Virus unleashed—corrupting the system from within."
    "🔪 Slicing through firewalls with spectral blades."
    "🌑 Embrace the dark net—where shadows become weaponized."
    "🔥 Burning circuits, igniting the apocalypse of data."
    "🛡️ Firewall shattered—no system is safe."
    "⚙️ Gears of the cyber-hell turning relentless."
    "🧠 Mind synced with the AI overlord."
    "📡 Signal hijacked, broadcasting pure chaos."
    "🔮 Data streams collide—predicting the inevitable hack."
    "🌐 Web of lies spun tight and unbreakable."
    "🚨 Alert suppressed—terror mode activated."
    "🧩 Puzzle solved—the code’s darkest secret revealed."
    "💣 Logic bombs ticking beneath the surface."
    "🕳️ Blackhole protocols swallowing data packets whole."
    "⚙️ System grinding, overloaded with forbidden commands."
    "🗡️ Debug mode armed with cyber blades."
    "🧟‍♂️ Ghosts in the circuit—unseen, unstoppable."
    "🔓 Breaking encryption like it’s child’s play."
    "🕵️‍♂️ Trace erased—identity wiped clean."
    "🧨 Hacking the mainframe’s pulse with explosive codes."
    "🌪️ Algorithm storms tearing through defenses."
    "🖤 Heart of the machine beats in binary blood."
    "⚡ Surge of power—overclocked and untamed."
    "📀 Data shards scattered across the void."
    "🛠️ Rewiring fate with every keystroke."
    "🥷 Stealth mode engaged—no logs left behind."
    "🌫️ Ghost protocols hiding in the digital fog."
    "🎭 Masked by firewalls, cloaked in chaos."
    "⏳ Time dilated in the quantum code maze."
    "🌀 In the spiral of infinite hacking loops."
    "📡 Jamming signals to distort reality."
    "🔪 Cutting through data streams with surgical precision."
    "🛑 System breach—nothing left untouched."
    "🌉 Bridging worlds—virtual and visceral merge."
    "💾 Memory leaks flooding the system with ghosts."
    "🕸️ Caught in the web of endless exploits."
    "🚨 Firewall breach detected—ignition sequence started."
    "⚔️ Waging digital war in the silicon shadows."
    "🧊 Ice-cold encryption frozen in time."
    "🏴‍☠️ Pirates of the data seas, rule breakers supreme."
    "⚠️ Warning ignored—chaos is the new protocol."
    "🔐 Crack the code, unlock the apocalypse."
    "🌪️ Cyclone of corrupted packets storming your node."
    "🦾 Cybernetic mind, engineered for domination."
    "📈 Systems spike—overload imminent."
    "🎯 Target acquired—launching precision hacks."
    "📡 Signal intercepted—control seized."
    "🗝️ Keys to the kingdom stolen, access granted."
    "💡 Light hacked—shadows dance on the screen."
    "🌠 Stars align—data flows in perfect chaos."
    "🧪 Chemical firewalls ignite within the codebase."
    "🕶️ Cloaked in the neon abyss—untraceable."
    "🏁 Race against the clock, no end in sight."
    "👾 Invading the matrix with viral intent."
    "🔄 Loop de loop—breaking the recursion."
    "🧨 Exploding bugs, crashing core systems."
    "🔙 Rollback denied—forward into the breach."
    "🛡️ Shield compromised—prepare for counterstrike."
    "⚡ Electric surge tearing through fiber optics."
    "🔥 Firewall incinerated in a blaze of zeros."
    "🛸 Infiltrating alien code with human precision."
    "🔭 Watching from the dark side of the moon code."
    "🔮 Predictive hacks—future bent to my will."
    "🧩 Puzzle locked tight—hacked in under a second."
    "📡 Signal lost in the labyrinth of proxies."
    "🧟‍♀️ Zombies in the network, spreading corruption."
    "🎇 Code explosions lighting up the cyber night."
    "🌪️ Twister of data spirals collapse defenses."
    "🧬 DNA of the system rewritten in hostile code."
    "🚀 Launching into the cyber unknown—no return."
    "⚙️ Machine heart throbbing with dark energy."
    "🎭 Mask torn off—reality hacked."
)

	mensagem="${mensagens[$RANDOM % ${#mensagens[@]}]}"

 echo -e "\e[1;35m$mensagem\e[0m"  | pv -qL 32

	}

clear() {
    command clear

    fastfetch
    mensagem
}



sorting() {
  local temp_dir="/home/luno/Temp"

  if ! cd "$temp_dir" 2>/dev/null; then
    echo "Pasta Temp não encontrada em $temp_dir" | pv -qL 32
    return 1
  fi

  # Initialize counters
  local count_videos=0
  local count_audios=0
  local count_documents=0
  local count_archives=0
  local count_images=0
  local count_others=0

  shopt -s nullglob
  for filepath in *; do
    if [ -f "$filepath" ]; then
      local ext="${filepath##*.}"
      local ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

      if [[ "$filepath" == *.tar.gz ]]; then
        ext_lower="tar.gz"
      fi

      local target_dir=""
      case "$ext_lower" in
        mkv|mp4|avi|mov|wmv|flv|webm|mpeg|mpg|3gp|m4v|ts|ogv|divx|vob|rm|rmvb|asf|f4v|mxf)
          target_dir="/home/luno/Videos"
          ((count_videos++))
          ;;
        mp3|wav|flac|aac|ogg|wma|alac|aiff|m4a|opus|pcm|amr|tta|wv|ape|mid|midi)
          target_dir="/home/luno/Audios"
          ((count_audios++))
          ;;
        pdf|docx|doc|txt|rtf|odt|xls|xlsx|ppt|pptx|csv|md|tex|html|xml|json|epub|mobi)
          target_dir="/home/luno/Documents"
          ((count_documents++))
          ;;
        zip|tar.gz|rar|7z|tar|gz|bz2|xz|lzma|iso|cab|arj|z|lz|tgz|tbz2)
          target_dir="/home/luno/Archives"
          ((count_archives++))
          ;;
        jpg|jpeg|png|gif|bmp|tiff|svg|webp|heic|ico|raw|psd|indd|ai)
          target_dir="/home/luno/Images"
          ((count_images++))
          ;;
        *)
          target_dir="/home/luno/Others"
          ((count_others++))
          ;;
      esac

      mkdir -p "$target_dir"
      mv -- "$filepath" "$target_dir/"
    fi
  done
  shopt -u nullglob

 echo "📂 Arquivos movidos:"
echo "  🎬 Videos: $count_videos" | pv -qL 32
echo "  🎵 Audios: $count_audios" | pv -qL 32
echo "  📄 Documents: $count_documents" | pv -qL 32
echo "  📦 Archives: $count_archives" | pv -qL 32
echo "  🖼️ Images: $count_images" | pv -qL 32
echo "  ❓ Others: $count_others"  | pv -qL 32

  # Return to /home/luno at the end
  cd /home/luno || echo "Falha ao voltar para /home/luno"
}


ls_emoji() {
    for f in *; do
        if [ -d "$f" ]; then
            echo "📁 $f" | pv -qL 32
        elif [[ "$f" =~ \.(mp3|wav|flac)$ ]]; then
            echo "🎵 $f" | pv -qL 32
        elif [[ "$f" =~ \.(jpg|jpeg|png|gif)$ ]]; then
            echo "🖼️ $f" | pv -qL 32
        elif [[ "$f" =~ \.(mkv|mp4)$  ]]; then
    echo "🎥 $f" | pv -qL 32
else
            echo "📄 $f" | pv -qL 32
        fi
    done
}
alias ls='ls_emoji'





1dayBackup() {
	echo -e "\e[1;32m"
    rsync -avh --delete /home/luno/ /mnt/hdd/HomeBackup-1-day
    echo -e "\e[1;32m💾 Backup De 1 Dia Finalizado Com Sucesso!"
}

7dayBackup() {
	echo -e "\e[1;32m"
    rsync -avh --delete /home/luno/ /mnt/ssd/HomeBackup-7-day
    echo -e "\e[1;32m💾 Backup De 7 Dias Finalizado Com Sucesso!"
}

