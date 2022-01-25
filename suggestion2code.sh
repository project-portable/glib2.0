#!/usr/bin/bash

function field() {
  local line=$(echo "${1}*4-1" | bc)
  echo "${issue}" | sed -n "${line}p"
}


issue=$(echo -e $(gh issue view ${ISSUE_URL} --json body | cut -d\" -f4))

desktop=$(field 1)
patch=$(field   2)
name=$(field    3)

[ "${patch}" = "Usar o nome genérico como nome" ] && {
  script="launchers_to_swap+=(\"${desktop}\")"
}

[ "${patch}" = "Ocultar um aplicativo" ] && {
  script="launchers_to_hide+=(\"${desktop}\")"
}

[ "${patch}" = "Definir um nome manualmente" ] && {
  script="sed \"/^Name\[/d;s|^Name=.*|Name=${name}|g\" ${desktop}"
}

[ "${patch}" = "Retirar o aplicativo do painel de controle" ] && {
  script="launchers_to_reset+=(\"${desktop}\")"
}

echo -e "@daigoasuka sugestão para $(echo ${patch} | tr  '[:upper:]' '[:lower:]') para o arquivo \`${desktop}\`, esse é o código:\n\n"'```'"bash\n${script}\n"'```'  > commit.md

gh issue comment "${ISSUE_URL}" --body-file commit.md
