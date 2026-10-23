# SPECS.md — Portfólio pessoal

> **Versão:** 1.0
> **Status:** decisões fechadas; em implementação
> **Última atualização:** 2026-10-23

Este documento é a fonte da verdade sobre **o que** o site é e **por quê**. Regras de **como**
implementar ficam em `AGENTS.md`.

---

## 1. Visão

Um portfólio pessoal publicado no GitHub Pages que apresente Victor Rizzotto como desenvolvedor
web em formação, mostre projetos reais com contexto técnico e o leve a uma conversa sobre
estágio.

**Não é**: blog, landing page de produto ou currículo em PDF na web.

## 2. Objetivo primário

**Conseguir um estágio em desenvolvimento web** (remoto ou híbrido).

Consequências para o design:
- O visitante principal é **recrutador técnico ou líder de engenharia**, que decide em segundos.
- Disponibilidade e nível de experiência precisam estar visíveis **na primeira dobra**.
- Projetos vêm antes da formação: prova concreta do que a pessoa sabe fazer.
- Toda seção termina em um caminho de contato.

## 3. Público

Primário: recrutadores técnicos e líderes de engenharia.
Secundário: colegas de curso, professores e comunidade dev.

## 4. Métricas de sucesso

- Lighthouse ≥ 95 nas quatro categorias (hoje: 100/100/100).
- LCP < 2,0 s em 4G; CLS < 0,1.
- Em 5 segundos, o visitante entende: quem é, o que sabe fazer, que busca estágio.
- Contato alcançável em um clique a partir de qualquer seção.

## 5. Escopo

**Dentro:** home em página única (hero, sobre, projetos, experiência, contato), 404, SEO
técnico, temas claro/escuro, deploy automático.

**Fora (por ora):** blog, CMS, formulário com backend, i18n, analytics, página individual por
projeto, download de currículo em PDF.

## 6. Arquitetura de informação

```
/                     home em página única
  #inicio             hero: nome, disponibilidade, posicionamento, dados objetivos
  #sobre              quem é e como trabalha
  #projetos           TapHub + este site
  #experiencia        formação e prática (linha do tempo) + bloco de disponibilidade
  #contato            e-mail e GitHub
/404.html             página de erro
```

Ordem justificada: **prova antes de credencial**. Recrutador quer ver o que a pessoa construiu
antes de ler a grade curricular.

## 7. Design system

### Cores (tokens)

| Token | Claro | Escuro | Uso |
|---|---|---|---|
| `--bg` | `#fbfcfe` | `#0b0e14` | fundo da página |
| `--bg-soft` | `#f3f6fb` | `#0f131c` | fundo sutil, chips, hover |
| `--surface` | `#ffffff` | `#12161f` | cards |
| `--text` | `#0f172a` | `#e6e9ef` | texto principal |
| `--muted` | `#52606d` | `#9aa4b2` | texto secundário |
| `--border` | `#e2e8f0` | `#1f2632` | bordas |
| `--accent` | `#4f46e5` | `#818cf8` | destaque, links, marcadores |
| `--accent-2` | `#0ea5e9` | `#38bdf8` | gradiente |
| verde | `#22c55e` | `#22c55e` | ponto de disponibilidade |

Direção escolhida: **dark técnico** com acento índigo/azul. Um único acento; verde reservado
exclusivamente para o estado "disponível".

### Tipografia

- Pilha do sistema (`ui-sans-serif, system-ui, …`), sem webfont.
- Mono do sistema para números de seção, tags, chips e períodos da linha do tempo.
- Títulos com `letter-spacing` negativo; texto corrido com largura de 45–75 caracteres.

### Espaçamento e forma

- Múltiplos de 4 px. Seções com `clamp(3.5rem, 9vw, 6.5rem)`.
- Raios: `16px` (cards/blocos), `10px` (controles), `999px` (botões, chips, status).

### Componentes

`skip-link` · `site-header` (brand, nav, theme-toggle) · `status` (pílula de disponibilidade) ·
`hero` + `hero-meta` (definition list) · `section` com `section-kicker` numerado · `card` com
`chips` · `timeline` + `timeline-item` · `availability` · `contact-item` · `site-footer` ·
`btn` (`primary`, `ghost`).

## 8. Stack e restrições

- HTML, CSS e JavaScript puros. **Sem build, sem dependências.**
- Um `style.css`, um `main.js`.
- Deploy estático via GitHub Actions no GitHub Pages (`build_type: workflow`).
- Compatibilidade: últimas 2 versões de Chrome, Safari, Firefox e Edge; Safari iOS 16+.
- `color-mix()` é usado para bordas e fundos derivados — degrada para cor sólida em navegadores
  sem suporte, sem quebrar layout.

## 9. Acessibilidade

Alvo WCAG 2.2 AA: contraste nos dois temas, navegação por teclado, foco visível, landmarks,
`prefers-reduced-motion`, `prefers-color-scheme`, `lang="pt-BR"`, nomes acessíveis em links com
ícone, `(abre em nova aba)` em links externos.

## 10. Performance

Orçamento: HTML + CSS + JS < 100 KB. Sem webfonts, sem imagens raster na primeira dobra.

## 11. SEO e metadados

- `title` e `description` com posicionamento e disponibilidade.
- `canonical` e `og:url` apontando para a URL de produção.
- Open Graph completo, exceto `og:image`.
- **Pendente:** `og:image` (1200×630), `robots.txt`, `sitemap.xml`, JSON-LD `Person`.

## 12. Deploy e domínio

- URL: `https://victorrizzotto.github.io/site-pessoal/`
- Deploy automático a cada push em `main`; aceita `workflow_dispatch`.
- Domínio próprio: **não** por enquanto. Se mudar, exige `CNAME` e ajuste do `<base href>` do
  `404.html`.

## 13. Conteúdo

| Item | Estado |
|---|---|
| Nome e headline | definidos |
| Disponibilidade | "Disponível para estágio", remoto ou híbrido |
| Formação | Ciência da Computação, Atitus, previsão 2030 |
| Base | Marau |
| Projetos | TapHub (link público) e este site |
| Contato | e-mail + GitHub (LinkedIn fora de escopo) |
| Foto/avatar | não existe — o site não depende de imagem |
| Currículo em PDF | não existe (fora de escopo) |

### Fatos usados nos textos

- TapHub: SaaS + produto NFC; React 19, TypeScript, Tailwind CSS 4, Supabase, Vite, Vercel.
  Código privado; demonstração pública em `https://empresa-wheat.vercel.app`.
- Este site: HTML, CSS e JavaScript puros; deploy via GitHub Actions.

## 14. Roadmap

| Fase | Entrega | Estado |
|---|---|---|
| 0 | Descoberta: entrevista e decisões | concluído |
| 1 | `AGENTS.md` + `SPECS.md` | concluído (v1.0) |
| 2 | Arquitetura de informação | concluído |
| 3 | Design system (status, chips, timeline, disponibilidade) | concluído |
| 4 | Implementação do layout | concluído |
| 5 | Conteúdo real (textos e projetos) | concluído |
| 6 | QA: acessibilidade, performance, responsivo | em andamento |
| 7 | SEO técnico (og:image, sitemap, JSON-LD) | pendente |

## 15. Decisões tomadas na entrevista

| # | Pergunta | Decisão |
|---|---|---|
| 1 | Área de atuação | Estudante de Ciência da Computação, em transição |
| 2 | Objetivo do site | Conseguir vaga (estágio) |
| 3 | Momento de carreira | Estudante / iniciante |
| 4 | Seções extras | Experiência / currículo (sem blog, serviços ou depoimentos) |
| 5 | Estilo visual | Manter dark técnico |
| 6 | Domínio | Manter `victorrizzotto.github.io/site-pessoal` |
| 7 | TapHub | Incluir com link público |
| 8 | Formação | Ciência da Computação — Atitus, previsão 2030 |
| 9 | Redes | LinkedIn de fora; apenas GitHub e e-mail |
| 10 | Oportunidade | Estágio, remoto ou híbrido |

## 16. Registro de decisões

| Data | Decisão | Motivo |
|---|---|---|
| 2026-10-23 | HTML/CSS/JS puros | Site pequeno; zero build reduz manutenção |
| 2026-10-23 | Repositório público `site-pessoal` | GitHub Pages gratuito exige repo público |
| 2026-10-23 | Deploy via GitHub Actions | Controle do artefato publicado |
| 2026-10-23 | Projetos antes de formação | Prova concreta pesa mais para recrutador técnico |
| 2026-10-23 | Um único acento + verde só para disponibilidade | Hierarquia: disponibilidade é a informação nº 1 |
| 2026-10-23 | Sem `og:image` por enquanto | Não há imagem; melhor ausente que quebrada |
