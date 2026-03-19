# Entendendo o Gerenciamento de Senhas

Este documento descreve como a API Guardiões da Saúde (Ruby on Rails + Devise) armazena e gerencia senhas, com o objetivo de avaliar a viabilidade de migração para um projeto NestJS.

---

## 1. Visão Geral

A API utiliza o gem **Devise 4.6.0** com o módulo `:database_authenticatable`. Internamente, o Devise delega o hash de senhas para o gem **BCrypt 3.1.12**, que implementa o algoritmo bcrypt/blowfish.

```
Senha em texto plano  →  BCrypt.create(senha, cost: 11)  →  encrypted_password
```

---

## 2. Como a senha é salva no banco

### 2.1 Campo no banco de dados

A senha nunca é armazenada em texto plano. O banco de dados contém apenas o campo:

```
encrypted_password  VARCHAR  NOT NULL  DEFAULT ""
```

Declarado na migration original (`db/migrate/20190213120928_devise_create_users.rb`):

```ruby
t.string :encrypted_password, null: false, default: ""
```

### 2.2 Formato do hash armazenado

O valor guardado em `encrypted_password` segue o formato padrão do **BCrypt (Modular Crypt Format)**:

```
$2a$11$<22 caracteres de salt base64><31 caracteres de hash base64>
```

| Parte | Valor | Descrição |
|-------|-------|-----------|
| `$2a$` | identificador | versão do algoritmo bcrypt |
| `11` | cost factor | número de rounds = 2^11 = 2048 iterações |
| `<22 chars>` | salt | gerado aleatoriamente a cada salvamento |
| `<31 chars>` | digest | hash resultante |

**Exemplo de valor real no banco:**

```
$2a$11$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
```

### 2.3 Custo (cost factor / stretches)

Configurado em `config/initializers/devise.rb`:

```ruby
config.stretches = Rails.env.test? ? 1 : 11
```

- **Produção/desenvolvimento:** `cost = 11` (≈ 2048 iterações, ~100–300 ms por hash em hardware moderno)
- **Testes:** `cost = 1` (para velocidade)

### 2.4 Pepper

Nenhum **pepper** está configurado (a linha correspondente está comentada no `devise.rb`):

```ruby
# config.pepper = '...'
```

Isso significa que o hash é gerado apenas com o salt aleatório embutido no próprio BCrypt, sem concatenação de segredo externo.

---

## 3. Fluxo de criação de senha

### 3.1 Cadastro de novo usuário

O registro passa pelo `RegistrationController < Devise::RegistrationsController`:

```
POST /user/signup
  params: { user: { email, password, user_name, ... } }
    → sign_up_params permite o campo :password
    → Devise chama resource.save
    → Devise::Models::DatabaseAuthenticatable#password= é chamado
    → BCrypt::Password.create(password, cost: 11) gera o hash
    → hash é salvo em encrypted_password
```

### 3.2 Validações aplicadas antes de salvar

Definidas em `app/models/user.rb`:

```ruby
validates :password,
  presence: true,
  length: { in: 8..255 },
  format: {
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d\s]).+\z/,
    allow_blank: true
  }
```

Regras:
- Obrigatória (não pode ser vazia)
- Entre **8 e 255 caracteres**
- Deve conter ao menos:
  - 1 letra **minúscula**
  - 1 letra **maiúscula**
  - 1 **dígito numérico**
  - 1 **caractere especial** (qualquer `[^a-zA-Z\d\s]`)

---

## 4. Fluxo de autenticação (login)

```
POST /user/login
  params: { user: { email, password } }
    → Devise::Strategies::DatabaseAuthenticatable executa:
    → BCrypt::Password.new(encrypted_password) == candidato
    → BCrypt compara o candidato com o hash salvo
    → Se OK: emite JWT (devise-jwt, expira em 1 mês)
    → Se não: retorna 401
```

O JWT é gerado com a chave armazenada em `Rails.application.credentials.devise[:secret_key]`.

---

## 5. Fluxo de redefinição de senha

### 5.1 Solicitar redefinição via e-mail

```
POST /email_reset_password  { email: "..." }
  → Localiza usuário pelo e-mail
  → Gera dois tokens:
      aux_code             = SecureRandom.hex(4)   # código de 8 chars enviado por e-mail
      reset_password_token = SecureRandom.hex(20)  # token de 40 chars (real token)
  → Salva ambos no banco (em texto plano)
  → Envia e-mail com aux_code via UserMailer
```

### 5.2 Trocar o código pelo token

```
POST /show_reset_token  { code: "<aux_code>" }
  → Busca usuário pelo aux_code
  → Retorna { reset_password_token: "..." }
```

### 5.3 Redefinir a senha

```
POST /reset_password  { reset_password_token, password, password_confirmation }
  → Busca usuário pelo reset_password_token
  → Chama user.reset_password(password, password_confirmation)
      → Valida as regras de senha
      → Se válida: BCrypt gera novo hash e salva em encrypted_password
      → Limpa reset_password_token e aux_code do banco
```

---

## 6. Fluxo de troca de senha (usuário autenticado)

```
POST /change_password  { old_password, password, password_confirmation }
  (requer JWT válido no header Authorization)
  → user.valid_password?(old_password)
      → BCrypt compara old_password com encrypted_password atual
  → Se correto: user.reset_password(password, password_confirmation)
      → Valida regras, gera novo hash BCrypt, salva
  → Se incorreto: retorna 401
```

---

## 7. Viabilidade de migração para NestJS

### 7.1 Compatibilidade do BCrypt

**Sim, a migração das senhas é tecnicamente viável.** O BCrypt é um algoritmo padronizado e interoperável. O NestJS (e o ecossistema Node.js) suportam BCrypt através do pacote `bcrypt` ou `bcryptjs`:

```typescript
import * as bcrypt from 'bcrypt';

// Verificar uma senha contra o hash do banco Rails/Devise:
const isMatch = await bcrypt.compare(plaintextPassword, encryptedPasswordFromDB);

// Criar novo hash com mesmo cost factor:
const hash = await bcrypt.hash(plaintextPassword, 11);
```

O hash gerado pelo Devise/BCrypt (`$2a$11$...`) é lido corretamente pelo `bcrypt` do Node.js.

### 7.2 O que pode ser migrado diretamente

| Item | Pode migrar? | Observação |
|------|-------------|------------|
| Hashes existentes em `encrypted_password` | ✅ Sim | Formato `$2a$` é padrão BCrypt, compatível com `bcrypt` npm |
| Cost factor (11) | ✅ Sim | `bcrypt.hash(pwd, 11)` usa o mesmo cost |
| Ausência de pepper | ✅ Sim | Sem configuração extra necessária |
| Lógica de validação de senha | ✅ Sim | Replicar regras: 8–255 chars, maiúscula, minúscula, dígito, especial |

### 7.3 O que precisa ser recriado no NestJS

| Item | Ação necessária |
|------|----------------|
| Hashing na criação/atualização | Usar `bcrypt.hash(password, 11)` antes de salvar |
| Verificação no login | Usar `bcrypt.compare(input, storedHash)` |
| Redefinição de senha | Recriar fluxo: `SecureRandom` equivalente → `crypto.randomBytes(20).toString('hex')` |
| Validação de complexidade | Replicar a regex: `/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d\s]).+$/` |

### 7.4 Roteiro de migração sugerido

1. **Exportar** os campos `email` e `encrypted_password` (já são hashes BCrypt válidos)
2. **Importar** no banco do NestJS sem alterar os valores de `encrypted_password`
3. **Configurar** o serviço de autenticação do NestJS para usar `bcrypt.compare` com o hash existente
4. **Implementar** a geração de novos hashes com `bcrypt.hash(password, 11)` para senhas criadas/alteradas após a migração
5. **Opcional:** forçar redefinição de senha no primeiro login se desejado (para atualizar hashes antigos com cost menor que 11)

### 7.5 Ponto de atenção: cost factor

Verificar se usuários antigos possuem hashes com cost diferente de 11 (ex.: criados em ambiente de teste com cost 1). Para garantir consistência, ao autenticar com sucesso no NestJS, pode-se re-hashear a senha com o cost correto:

```typescript
const isMatch = await bcrypt.compare(plaintext, storedHash);
if (isMatch) {
  const rounds = bcrypt.getRounds(storedHash);
  if (rounds !== 11) {
    const newHash = await bcrypt.hash(plaintext, 11);
    await userRepository.update(userId, { encrypted_password: newHash });
  }
}
```

---

## 8. Resumo Técnico

```
Algoritmo:     BCrypt (Blowfish)
Versão hash:   $2a$
Cost factor:   11 (produção), 1 (testes)
Salt:          Aleatório, embutido no hash (22 chars base64)
Pepper:        Não utilizado
Campo DB:      encrypted_password (VARCHAR, NOT NULL)
Gem Ruby:      bcrypt 3.1.12 (via devise 4.6.0)
Equivalente JS: npm install bcrypt  →  bcrypt.compare / bcrypt.hash
Migração:      Compatível — hashes existentes funcionam no NestJS sem alteração
```
