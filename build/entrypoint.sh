#!/bin/bash

#File to edit
file='/var/www/html/config.php'

#Searches $1 and replaces with $2 in $file
function search_and_replace {
  sed -i 's|'$1'|'$2'|g' "$file"
}

#RWSOLS
#Does everything for ENV-vars with RWSOLS_*
compgen -A variable RWSOLS_ | while read v; do
  #Checks if REPLACE_envvar is in $file
  if grep -q "REPLACE_$v" "$file"; then
    echo "search_and_replace REPLACE_$v with ${!v}"
    search_and_replace REPLACE_$v ${!v}
  fi
done

#Settings RWSOLS_HASH for keyphrase
RWSOLS_HASH=$(echo -n $PASSPHRASE | sha256sum | cut -d " " -f 1)
search_and_replace RWSOLS_HASH $RWSOLS_HASH


#APACHE2 port mapping
echo "search_and_replace port 80 with $APACHE2_PORT"
sed -i 's|'80'|'$APACHE2_PORT'|g' '/etc/apache2/ports.conf'


#Starting apache2
service apache2 reload
exec apache2-foreground


#TODO
# 1. PHP-Arrays mit env vars testen: z.B. RWSOLS_COMPUTER_NAME="PcTest","PcTest1"
# 2. Für alle Config-Settings Env vars erstellen
# 3. Hash for Keyphrase erstellen
