#!/usr/bin/bash

function field() {
  local line=$(echo "${1}*4-1" | bc)
  echo "${issue}" | sed -n "${line}p"
}


issue=$(echo -e $(gh issue view ${ISSUE_URL} --json body | cut -d\" -f4))

desktop=$(field 1)
patch=$(field   2)
name=$(field    3)



script="

#----- Esse trecho adiciona ' $(echo ${local} | tr  '[:upper:]' '[:lower:]')' ----#

line=\$(cat \${desktop} | grep -n -A 10000 -E '^\[Desktop Entry]|^Exec=' | grep -m1 Exec= | cut -d\: -f1)

command_line=\$(sed -n \${line}p \${desktop}  | cut -c 6- | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')

parameters=\$(echo \${command_line} | sed 's/[^ ]* //')
command=\$(echo \${command_line} | sed 's|[[:space:]].*||g')

"

[ "${local}" = "No inicio" ] && {
  script="${script}parameters=\"${argumentos} \${parameters}\"\n\n"
} 

[ "${local}" = "No final" ] && {
  script="${script}parameters=\"\${parameters} ${argumentos}\"\n\n"
}

[ "${local}" = "Antes do comando" ] && {
  script="${script}command=\"${argumentos} \${command}\"\n\n"
}


script="${script}sed -i \"\${line}s/^Exec=/Exec=${command} ${parameters}/g\" \${desktop}"



echo -e "@daigoasuka sugestão para $(echo ${patch} | tr  '[:upper:]' '[:lower:]') para o arquivo \`${desktop}\`, esse é o código:\n\n"'```'"bash\n${script}\n"'```'  > commit.md

gh issue comment "${ISSUE_URL}" --body-file commit.md
