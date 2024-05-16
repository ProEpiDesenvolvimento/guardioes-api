# Guardiões da Saúde API

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Esse repositório é referente à API usada no aplicativo [Guardiões Da Saúde](https://github.com/proepidesenvolvimento/guardioes-app). Logo ela é responsável por todas as requests que são feitas no aplicativo assim como o armazenamento dos dados no banco de dados.

Veja mais em nossa página [clicando aqui](https://proepidesenvolvimento.github.io/guardioes-api/).

## Tecnologias

Usamos nessa API:

- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)

## Como levantar o ambiente

### O que fazer antes

1. Crie um arquivo chamado 'master.key' na pasta '/config', esse arquivo deve conter uma chave para tudo funcionar corretamente. Você pode conseguir essa chave com algum desenvolvedor do projeto.

2. Crie um arquivo '.env' na pasta raiz do projeto, esse arquivo deve conter as seguintes variáveis de ambiente e seus valores:

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
EPHEM_API_URL=
```

O passo 2 pode ser pulado se sua intenção for **apenas** de rodar a API.

### Levantando

#### Sem logs do rails

```shell
docker-compose build
docker-compose up -d
```

#### Com logs do rails

```shell
docker-compose up
```

### O que fazer depois

Se o ambiente inicializou corretamente, agora basta migrar a base de dados com o comando a seguir:

```shell
docker-compose run web rake db:migrate
```

Teste se tudo está funcionando entrando em [http://localhost:3001](http://localhost:3001]). Você deverá ver um JSON se tudo funciona normalmente.

Após a migração da base de dados, para o correto funcionamento de todos os features da API, você deve iniciar os cronjobs, para fazer isso:

```
docker-compose run -d web bundle exec crono RAILS_ENV=development
```

## Erros

### Rails

Caso você tome o seguinte erro:

```Shell
Rails - FATAL: database “myapp_development” does not exist
```

É preciso criar o banco de dados, então rode:

```shell
docker-compose run web rake db:create
```

E então tente de novo migra o banco de dados, caso dê erro, reinicie o processo.

### Key

Caso você tome o seguinte erro:

```shell
"/config/initializers/devise.rb: undefined method '[]' for nil:NilClass"
```

Significa que você está tentando levantar o ambiente sem a key citada acima.

### Postgres

O postgres é uma grande fonte de erros.

```shell
"Database '...' does not exist"
```

Basta criar a base de dados

```shell
docker-compose exec db bash
...
psql -U postgres
...
create database [nome da base de dados];
```

### Testes

Primeiramente realize o setup do banco de dados de testes

```shell
docker-compose exec web bash
```

```shell
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:schema:load RAILS_ENV=test
```

Depois basta escrever

```shell
rspec
```

E caso queria testar um modulo em específico

```shell
rspec spec/[pasta]/[arquivo]
```

### Continuous Integration

Quando uma novo commit é feito, este sobre pro [Travis](https://travis-ci.org/), onde é rodada a bateria de testes para certificar que nada quebrou.

## License & copyright

ProEpi, Associação Brasileira de Profissionais de Epidemiologia de Campo

Licensed under the [Apache License 2.0](LICENSE.md).
