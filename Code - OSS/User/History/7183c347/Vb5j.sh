#!/bin/bash

# Backup com rsync
rsync -avh --delete /home/luno/ /mnt/ssd/HomeBackup-7-day

# Mensagem de sucesso em verde com emoji 🎉
echo -e "\e[1;32mBackup finalizado com sucesso! 🎉\e[0m"
