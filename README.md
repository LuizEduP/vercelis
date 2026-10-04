# LUVIX · Leitor e gerenciador de QR Codes

Site responsivo para ler QR Codes e administrar links intermediários permanentes. Cada QR Code aponta para uma rota fixa (`/r/identificador`); o destino é consultado no Supabase e pode ser editado sem trocar o QR impresso.

- Leitor em tempo real com [html5-qrcode](https://github.com/mebjas/html5-qrcode)
- Área de gerenciamento protegida por autenticação Supabase
- Dados compartilhados e persistidos no Supabase
- QR Codes baixáveis em PNG
- Os links escaneados pelo leitor continuam salvos apenas no navegador (LocalStorage)

## Rodar localmente

A API de câmera exige contexto seguro (`https://` ou `localhost`). Por isso, **não abra o
arquivo com `file://`** — use um servidor local:

```bash
npx serve .
# ou
npx http-server .
```

Depois acesse `http://localhost:3000` (ou a porta indicada).

## Configurar gerenciamento e redirecionamentos

O projeto precisa de um projeto Supabase para compartilhar os registros entre dispositivos.

1. Crie um projeto no Supabase.
2. No **SQL Editor**, execute o conteúdo de [`assets/supabase-schema.sql`](./assets/supabase-schema.sql).
3. Em **Authentication**, crie uma conta de usuário para a pessoa administradora e desative novos cadastros públicos. A página não oferece criação de contas.
4. Em [`assets/supabase-config.js`](./assets/supabase-config.js), preencha o Project URL e a chave pública `anon`/`publishable` do projeto:

   ```js
   window.LUVIX_SUPABASE_CONFIG = {
     url: 'https://SEU-PROJETO.supabase.co',
     anonKey: 'SUA_CHAVE_PUBLICA_ANON',
   };
   ```

   A chave pública pode ser usada no navegador. **Nunca coloque a chave `service_role` nesse arquivo.**
5. Publique ou faça novo deploy na Vercel. Abra **Gerenciar QR** e entre com a conta criada.
6. Crie um registro para cada empresa, baixe o PNG e teste o QR com o endereço de produção antes de imprimir.

O QR impresso contém o domínio do site e a rota `/r/identificador`. Mantenha esse domínio e o projeto Supabase ativos para que os QR Codes continuem funcionando. Alterar o domínio exige substituir os QR Codes já impressos.

## Deploy na Vercel

O site é estático e não exige etapa de build. Opções:

### 1) CLI (mais rápido)

```bash
npm i -g vercel
vercel          # ambiente de preview
vercel --prod   # produção
```

### 2) Git

1. Suba esta pasta do projeto para um repositório (GitHub/GitLab/Bitbucket).
2. Em [vercel.com/new](https://vercel.com/new), importe o repositório.
3. Preset: **Other** (sem framework, sem build command), **Root Directory**: `.`
4. Clique em **Deploy**.

### Observações importantes

- A Vercel serve tudo por `https://`, então a câmera funciona em produção sem mudanças.
- `vercel.json` reescreve as rotas públicas (incluindo `/r/identificador`) para `index.html`, preservando os arquivos de `assets/`.
- A leitura pública do destino é feita pela função `resolve_qr_destination`; as alterações na tabela exigem autenticação e passam por Row Level Security.
- Os links capturados pelo leitor são locais; os QR Codes gerenciados ficam no banco Supabase e podem ser acessados após login em outro dispositivo.
