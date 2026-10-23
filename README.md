# site-pessoal

Site pessoal de Victor Rizzotto — HTML, CSS e JavaScript puros, publicado no GitHub Pages.

**No ar em:** https://victorrizzotto.github.io/site-pessoal/

## Estrutura

```
.
├─ index.html                  # página única (início, sobre, projetos, contato)
├─ 404.html                    # página de erro
├─ assets/
│  ├─ css/style.css            # estilos e temas (claro/escuro)
│  ├─ js/main.js               # tema, menu mobile, link ativo, animações
│  └─ img/favicon.svg          # ícone
├─ .github/workflows/deploy.yml # deploy automático no GitHub Pages
└─ .gitignore
```

Sem dependências, sem build. Não precisa de `npm install`.

## Desenvolvimento local

Como o site usa caminhos relativos, abrir o `index.html` direto no navegador funciona.
Para simular o ambiente de produção, use um servidor local:

```sh
python3 -m http.server 8000
```

Depois acesse http://localhost:8000

## Deploy

Cada push na branch `main` dispara o workflow `.github/workflows/deploy.yml`, que publica o
site no GitHub Pages. Também é possível rodar manualmente em **Actions → Deploy para GitHub
Pages → Run workflow**.

O Pages está configurado com **Source: GitHub Actions** (`build_type: workflow`).

> **Se renomear o repositório:** o arquivo `404.html` usa `<base href="/site-pessoal/">` para
> funcionar em qualquer subcaminho. Atualize esse valor para o novo nome do repositório.

## Como editar o conteúdo

Tudo fica em `index.html`:

| O que mudar | Onde |
|---|---|
| Nome, cargo e frase de apresentação | seção `<section class="hero">` |
| Texto "Sobre" | seção `<section class="section" id="sobre">` |
| Projetos | lista `<ul class="cards">` — edite ou remova os cards |
| E-mail, GitHub, LinkedIn | seção `<section class="section" id="contato">` |
| Cores do site | variáveis no topo de `assets/css/style.css` (`--accent`, `--accent-2`, etc.) |

### Trocar as cores

No topo de `assets/css/style.css`, ajuste:

```css
--accent: #4f46e5;   /* cor principal  */
--accent-2: #0ea5e9; /* cor secundária */
```

Há blocos separados para tema claro e escuro — atualize os dois (e o `favicon.svg`).

## Licença

Conteúdo pessoal. Sinta-se livre para usar a estrutura como referência.
