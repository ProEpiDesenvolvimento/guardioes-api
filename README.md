# Guardiões da Saúde API

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Bem-vindo ao repositório da API do aplicativo mobile **[Guardiões Da Saúde](https://github.com/proepidesenvolvimento/guardioes-app)**.  
Essa API é responsável por gerenciar as requisições realizadas pelo aplicativo e armazenar os dados em um banco de dados.

Para saber mais sobre o projeto, visite nossa página oficial **[clicando aqui](https://proepidesenvolvimento.github.io/guardioes-api/)**.

---

## Tecnologias Utilizadas

Esta API foi desenvolvida utilizando as seguintes tecnologias:

- **[Ruby on Rails](https://rubyonrails.org/)**
- **[PostgreSQL](https://www.postgresql.org/)**
- **[Docker](https://www.docker.com/)**

---

## Configuração do Ambiente de Desenvolvimento

### Pré-requisitos

Antes de começar, você precisa garantir que o seguinte software está instalado e configurado no seu computador:

- **[Docker](https://www.docker.com/)**

---

### Passos Iniciais

1. **Arquivo `master.key`:**  
   Este arquivo é necessário para gerenciar a criptografia do Rails.

   - Crie o arquivo `master.key` na pasta `/config` do projeto.
   - O conteúdo da chave deve ser solicitado a um dos desenvolvedores do projeto.

2. **Arquivo `.env`:**  
   As variáveis de ambiente necessárias para o funcionamento completo da API devem ser configuradas neste arquivo.  
   Crie um arquivo `.env` na raiz do projeto com o seguinte conteúdo (preencha os valores conforme necessário):

   ```
   NITTER_URL=
   MAILER_SMTP_ADDRESS=
   MAILER_EMAIL=
   MAILER_PASSWORD=
   GODATA_KEY=
   CSV_DATA_KEY=
   METABASE_SITE_URL=
   METABASE_SECRET_KEY=
   ONESIGNAL_API_URL=
   ONESIGNAL_APP_ID=
   EPHEM_PROD_API_URL=
   EPHEM_HOMOLOG_API_URL=
   ```

Nota: Caso seu objetivo seja apenas rodar a API para testes básicos, esse passo pode ser ignorado.

## Levantando o Ambiente

1. Construa o projeto:

Este comando cria as imagens dos containers:

```
docker-compose build
```

2. Inicie os containers:

Após o build, rode os containers com:

```
docker-compose up
```

3. Migre o banco de dados:

Certifique-se de que a estrutura do banco de dados está correta:

```
docker-compose run web rake db:migrate
```

4. Teste a API:

Acesse http://localhost:3001 no seu navegador.  
Se tudo estiver funcionando corretamente, você verá um JSON de resposta.

## Configuração Extra

### Iniciar Cron Jobs

Algumas funcionalidades da API dependem de tarefas agendadas. Para iniciar os cron jobs, utilize:

```
docker-compose run -d web bundle exec crono RAILS_ENV=development
```

### Criar App e Administrador

Para utilizar o aplicativo mobile e o painel administrativo, você deve criar um app e um administrador no banco de dados:

1. Entre no terminal do container:

```
docker-compose exec web bash
```

2. Acesse o console do Rails:

```
rails console
```

3. Crie um app para o Brasil:

```
App.create(owner_country: "Brazil", app_name: "Guardioes da Saude", twitter: "appguardioes")
```

4. Crie um administrador para esse app:

```
Admin.create(email: "root@admin.com", password: "12345678", first_name: "Admin", last_name: "Root", is_god: true, app_id: 1)
```

Após isso, você pode acessar o painel administrativo via [guardioes-web](https://github.com/proepidesenvolvimento/guardioes-web) e criar usuários através do aplicativo mobile [guardioes-app](https://github.com/proepidesenvolvimento/guardioes-app).

## Solução de Problemas

Aqui estão alguns erros comuns que podem ocorrer e como resolvê-los:

Erros com o Rails

- **Erro:**

  ```
  FATAL: database “myapp_development” does not exist
  ```

  Solução:
  Crie o banco de dados:

  ```
  docker-compose run web rake db:create
  ```

- **Erro:**

  ```
  /config/initializers/devise.rb: undefined method '[]' for nil:NilClass
  ```

  Solução: Certifique-se de que o arquivo master.key foi configurado corretamente.

Erros com o PostgreSQL

- **Erro:**

  ```
  Database '...' does not exist
  ```

  Solução:
  Crie o banco de dados diretamente no container:

  ```
  docker-compose exec db bash
  ```

  Depois, dentro do container:

  ```
  psql -U postgres
  create database [nome_da_base];
  ```

## Executando Testes Automatizados

Para garantir que as alterações no código não quebrem o sistema, rode os testes automatizados:

Configure o banco de dados de testes:

```
docker-compose exec web bash
```

Depois, rode os comandos:

```
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:schema:load RAILS_ENV=test
```

Execute os testes com o RSpec:

```
rspec
```

Para rodar testes específicos, indique o caminho:

```
rspec spec/[pasta]/[arquivo]
```

## Integração Contínua

Este repositório utiliza o GitHub Actions para garantir qualidade no código.
Sempre que um commit é enviado, uma bateria de testes é executada para identificar problemas.

## Licença

ProEpi, Associação Brasileira de Profissionais de Epidemiologia de Campo
Licensed under the [Apache License 2.0](LICENSE.md).

Se precisar de ajuda, abra uma issue no repositório ou entre em contato com a equipe de desenvolvimento!
