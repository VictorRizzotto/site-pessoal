# site-pessoal

Portfólio de Victor Rizzotto — HTML, CSS e JavaScript puros, publicado no GitHub Pages.

**No ar em:** https://victorrizzotto.github.io/site-pessoal/

O objetivo do site é conseguir um estágio em desenvolvimento web. Cada decisão de conteúdo e
design está documentada em [`SPECS.md`](./SPECS.md); as regras de implementação ficam em
[`AGENTS.md`](./AGENTS.md).

## Estrutura

```
.
├─ index.html                   # página única
├─ 404.html                     # página de erro
├─ assets/
│  ├─ css/style.css             # estilos e temas (claro/escuro)
│  ├─ js/main.js                # tema, menu mobile, link ativo, animações
│  └─ img/favicon.svg           # ícone (também usado no cabeçalho)
├─ .github/workflows/deploy.yml # deploy automático no GitHub Pages
├─ scripts/check.sh             # verificações automáticas
├─ AGENTS.md                    # instruções de trabalho (design + código)
├─ SPECS.md                     # especificação do produto
├─ TODO.md                      # roteiro executável de tarefas e testes
└─ .gitignore
```

Sem dependências, sem build. Não precisa de `npm install`.

## Seções da página

| Âncora | Conteúdo |
|---|---|
| `#inicio` | disponibilidade, nome, posicionamento, formação/base |
| `#sobre` | quem é e como trabalha |
| `#projetos` | TapHub e este site |
| `#experiencia` | linha do tempo (formação e prática) + bloco de disponibilidade |
| `#contato` | e-mail e GitHub |

## Desenvolvimento local

```sh
python3 -m http.server 8000
```

Depois acesse http://localhost:8000

## Verificações

```sh
bash scripts/check.sh
```

Valida estrutura, metadados, acessibilidade estática, âncoras, arquivos referenciados, peso e
configuração de deploy. Sai com código `0` quando está tudo certo. O roteiro completo de tarefas
e testes manuais está em [`TODO.md`](./TODO.md).

## Deploy

Cada push na branch `main` dispara o workflow, que publica o site no GitHub Pages. Também é
possível rodar manualmente em **Actions → Deploy para GitHub Pages → Run workflow**.

O Pages está configurado com **Source: GitHub Actions** (`build_type: workflow`).

> **Se renomear o repositório:** o arquivo `404.html` usa `<base href="/site-pessoal/">` para
> funcionar em qualquer subcaminho. Atualize esse valor para o novo nome do repositório.

## Como editar o conteúdo

| O que mudar | Onde |
|---|---|
| Disponibilidade e headline | `<section class="hero">` em `index.html` |
| Formação, previsão de formatura, base | `<dl class="hero-meta">` |
| Texto "Sobre" | `<section id="sobre">` |
| Projetos e tecnologias | `<ul class="cards">` (chips = tecnologias) |
| Linha do tempo e bloco de disponibilidade | `<section id="experiencia">` |
| E-mail e GitHub | `<section id="contato">` |
| Cores | variáveis no topo de `assets/css/style.css` |

### Trocar as cores

```css
--accent: #4f46e5;   /* cor principal  */
--accent-2: #0ea5e9; /* cor secundária */
```

Há blocos separados para tema claro e escuro — atualize os dois (e o `favicon.svg`).

## Pendências conhecidas

- `og:image` (1200×630) para compartilhamento em redes sociais.
- `robots.txt`, `sitemap.xml` e JSON-LD `Person`.
- Currículo em PDF para download.

## Licença

Conteúdo pessoal. Sinta-se livre para usar a estrutura como referência.
