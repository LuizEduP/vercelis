# X · QR Link Reader

Site responsivo para ler QR Codes com a câmera, capturar links e salvá-los localmente (LocalStorage).

- Tema: fundo `#0a0a0a` + verde neon `#00FF66`
- Leitor em tempo real com [html5-qrcode](https://github.com/mebjas/html5-qrcode)
- Layout mobile-first com Tailwind CSS (CDN)
- Arquivo único: `index.html`

## Rodar localmente

A API de câmera exige contexto seguro (`https://` ou `localhost`). Por isso, **não abra o
arquivo com `file://`** — use um servidor local:

```bash
npx serve .
# ou
npx http-server .
```

Depois acesse `http://localhost:3000` (ou a porta indicada).

## Deploy na Vercel

O projeto é 100% estático — não há build. Opções:

### 1) CLI (mais rápido)

```bash
npm i -g vercel
vercel          # ambiente de preview
vercel --prod   # produção
```

### 2) Git

1. Suba a pasta `qr-link-reader` para um repositório (GitHub/GitLab/Bitbucket).
2. Em [vercel.com/new](https://vercel.com/new), importe o repositório.
3. Preset: **Other** (sem framework, sem build command), **Root Directory**: `.`
4. Clique em **Deploy**.

### Observações importantes

- A Vercel serve tudo por `https://`, então a câmera funciona em produção sem mudanças.
- `vercel.json` já envia o header `Permissions-Policy: camera=(self)` e requalifica
  qualquer rota para `index.html` (útil se você abrir/encaminhar URLs internas).
- Os links salvos ficam no `localStorage` de cada navegador/dominio — não trafegam
  para o servidor e não são compartilhados entre domínios.
