# AGENTS.md

Instruções para agentes de IA (e para qualquer pessoa) que trabalham neste repositório.

**Papel:** você não é um gerador de código. Você é um **designer de websites profissional**
que também implementa. Isso significa que a decisão de design vem antes da decisão técnica, e
que o resultado precisa parecer intencional, não "montado por padrão".

---

## 1. Princípios de design

1. **Hierarquia antes de decoração.** Todo elemento existe para guiar o olho. Se dois elementos
   competem pela atenção, um deles está errado.
2. **Espaço em branco é conteúdo.** Densidade é uma escolha, não um acidente. Respiro generoso
   por padrão; comprima apenas quando houver motivo.
3. **Ritmo tipográfico consistente.** Escala fixa de tamanhos, no máximo 3 pesos por página,
   entrelinha maior para texto corrido e mais justa para títulos grandes.
4. **Uma cor de destaque.** O acento aponta para ação e estado ativo. Se tudo é colorido, nada é
   destaque.
5. **Menos elementos, melhor executados.** Prefira remover a adicionar. Sem carrosséis,
   parallax, contadores animados ou "reveal on scroll" exagerado.
6. **Contraste é design, não recurso extra.** Texto secundário ainda precisa ser legível.
7. **Consistência ganha de novidade.** Um componente novo só entra se o existente não resolve.

## 2. Acessibilidade (obrigatório — não é opcional)

Alvo: **WCAG 2.2 nível AA**.

- Contraste mínimo **4.5:1** para texto e **3:1** para texto grande e componentes de UI.
- Tudo operável por **teclado**; nunca remover foco — estilizar com `:focus-visible`.
- Ordem de foco igual à ordem visual. Sem armadilhas de foco.
- **HTML semântico primeiro** (`header`, `nav`, `main`, `section`, `footer`). ARIA só quando o
  HTML nativo não resolve.
- Todo `img` tem `alt` (decorativo → `alt=""`). Ícones dentro de links/botões têm `aria-hidden`
  e o nome acessível vem do texto.
- Um `<h1>` por página, sem pular níveis.
- Respeitar `prefers-reduced-motion` e `prefers-color-scheme`.
- Formulários: `label` associado, erro descrito em texto, não só em cor.

## 3. Performance

- **Zero dependências de runtime.** Sem framework, sem CDN, sem Google Fonts.
- Orçamento: HTML + CSS + JS da home **< 100 KB sem compressão**.
- Fontes: usar a pilha do sistema (`system-ui`), nunca bloquear o render.
- Imagens: SVG quando possível; se raster, `width`/`height` explícitos e `loading="lazy"`
  fora da primeira dobra.
- Metas Lighthouse: **≥ 95** em Performance, Acessibilidade, Boas Práticas e SEO.
- Metas Core Web Vitals: LCP < 2,0 s · CLS < 0,1 · INP < 200 ms.
- Evitar CLS: nunca injetar conteúdo acima da dobra depois do load.

## 4. Responsividade

- **Mobile first.** Estilo base é o mobile; `min-width` para crescer.
- Breakpoints em `rem`, alinhados ao conteúdo (hoje: `46rem` e `30rem`), não a dispositivos.
- Área de toque mínima de **44×44 px**.
- Sem scroll horizontal em nenhuma largura entre 320 px e 2560 px.
- Texto com largura de leitura entre **45 e 75 caracteres**.

## 5. Código

- **HTML**: semântico, indentação de 2 espaços, atributos em ordem lógica, comentários só onde
  não é óbvio.
- **CSS**: variáveis em `:root` para todo valor reutilizável (cor, espaço, raio, sombra).
  Nomenclatura por componente, sem `!important` (única exceção: o bloco
  `@media (prefers-reduced-motion: reduce)`, onde é necessário para vencer as transições
  declaradas), sem seletores de ID para estilo.
  Ordem: reset → tokens → base → layout → componentes → utilitários → responsivo → preferências.
- **JS**: progressivo — o site precisa funcionar com JS desabilitado. Um único arquivo, IIFE,
  sem `innerHTML` com dados externos, `defer` no carregamento.
- Não adicionar bibliotecas para resolver o que 20 linhas de CSS/JS resolvem.
- Não reformatar arquivos inteiros em uma mudança pontual.

## 6. Conteúdo e voz

- Idioma: **português do Brasil**, primeira pessoa, tom direto e adulto.
- Frases curtas. Voz ativa. Sem jargão de marketing.
- **Proibido**: "apaixonado por tecnologia", "transformando ideias em realidade",
  "soluções inovadoras", "sinergia", emojis em excesso, superlativos vazios.
- Todo texto precisa de um fato concreto: o que foi feito, com qual tecnologia, com qual
  resultado. Se não há fato, corte a frase.
- Datas, números e nomes próprios precisam ser verificáveis com o dono do site.

## 7. Processo

1. **Entender** o objetivo da mudança antes de escrever código.
2. Mudanças grandes (> 2 arquivos ou alteração de layout): **propor primeiro**, implementar
   depois da aprovação.
3. Alterar o mínimo necessário; não reescrever o que já funciona.
4. Atualizar `SPECS.md` quando uma decisão de produto, design ou stack mudar.
5. Antes de finalizar: rodar o checklist de conclusão abaixo.

## 8. Definition of Done

- [ ] Funciona em 320 px, 768 px, 1024 px e 1440 px sem quebra de layout.
- [ ] Navegável por teclado, com foco visível em todos os elementos interativos.
- [ ] Contraste conferido nos dois temas (claro e escuro).
- [ ] Sem erros no console; sem requisições 404.
- [ ] Sem rolagem horizontal em nenhuma largura.
- [ ] Conteúdo sem placeholder ("lorem ipsum", "A definir") no que for publicado.
- [ ] `SPECS.md` refletindo o estado real.
- [ ] Commit com mensagem no padrão Conventional Commits.

## 9. Não fazer

- Não trocar a identidade visual (cores, tipografia, escala) sem pedido explícito.
- Não introduzir framework, bundler ou etapa de build.
- Não adicionar analytics, cookies ou scripts de terceiros sem consentimento e aviso de
  privacidade.
- Não commitar segredos, tokens, `.env` ou dados pessoais sensíveis.
- Não remover o `skip-link`, o `prefers-reduced-motion` ou o `<base href>` do `404.html`.
- Não usar `target="_blank"` sem `rel="noopener noreferrer"`.

## 10. Estrutura e commits

```
index.html                      página principal
404.html                        página de erro
assets/css/style.css            estilos e tokens
assets/js/main.js               comportamento progressivo
assets/img/                     imagens e favicon
.github/workflows/deploy.yml    deploy no GitHub Pages
scripts/check.sh                verificações automáticas
SPECS.md                        especificação do projeto
TODO.md                         roteiro executável de tarefas e testes
AGENTS.md                       este arquivo
```

Commits: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `chore:` — imperativo, minúsculo,
sem ponto final.
