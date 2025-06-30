# Monitor de Website com PowerShell e GitHub Actions

Este projeto utiliza um script PowerShell, executado de forma automática e gratuita através do GitHub Actions.
Quando uma alteração é detetada, uma notificação é enviada para o seu celular através do ntfy.sh.

---
## ► Ferramentas utilizadas nessa versão:

* PowerShell;
* GitHub Actions;
* GitHub Gist;
* ntfy.sh;
* GitHub Secrets;

---
## ► Configurações Iniciais:

1.  **ntfy.sh:** Crie um endpoint único e copie para a aplicação (é só seguir os passos do site/app).

2.  **GitHub Gist:** Crie um arquivo em [https://gist.github.com/](https://gist.github.com/) que armazenará a string com a última data para comparação (lembre-se de salvar o id).

3.  **GitHub Token (PAT):** Crie um Personal Access Token (PAT) na aba 'Developer settings' do GitHub com a permissão (scope) `gist` (copie o token gerado, ele não será mostrado novamente).

4.  **GitHub Secrets:** No seu repositório, vá até 'Settings > Secrets and variables > Actions' e crie um novo 'repository secret' com o nome `GIST_PAT` e cole o token anterior.

5.  **Edição dos Ficheiros:** Por fim, edite as variáveis nos ficheiros do projeto com as suas informações:
    * No ficheiro `.github/workflows/monitor.yml`, altere o `GIST_ID` para o ID do seu Gist e ajuste a agenda `cron` se desejar.
    * No ficheiro `Check-Caminhada.ps1`, altere as variáveis `$url` e `_ntfyTopic_`.

---
## ► Recomendações:

Recomendo testar manualmente o script no GitHub Actions, o que deve enviar imediatamente uma notificação para o seu celular ao aceder à primeira data. Tenha em mente que este script foi feito a pensar num site específico, pegando um elemento de uma classe do HTML para economizar recursos e não precisar de comparar o site inteiro a cada 5 minutos.

---
## ► Considerações Finais:

Talvez a linguagem PowerShell não seja a ideal para este tipo de solução, mas tendo um rascunho para rodar no meu PC Windows, quis aproveitá-lo aqui para não ter que deixar o meu computador ligado.
