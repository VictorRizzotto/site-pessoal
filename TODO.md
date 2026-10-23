# TODO.md

Roteiro executável do projeto **site-pessoal** (portfólio de Victor Rizzotto).

Este arquivo foi escrito para ser executado **literalmente**, por alguém (ou algum modelo) sem
capacidade de inferência. Cada tarefa tem: comando exato, saída esperada e o que fazer se falhar.

---

## 0. Regras para quem executa

1. **Execute na ordem.** Não pule tarefas, não reordene, não agrupe.
2. **Nunca invente conteúdo.** Não escreva nomes, datas, URLs, números ou tecnologias que não
   estejam escritos neste arquivo ou no repositório. Se faltar informação, pare e pergunte.
3. **Verifique sempre.** Depois de cada tarefa, rode o bloco `VERIFICAR` e compare com a
   `SAÍDA ESPERADA`. Se for diferente, vá para o item `SE FALHAR` e **pare**.
4. **Um commit por fase.** Nunca faça commit de duas fases juntas.
5. **Nunca use `sudo`.** Nada neste projeto exige permissão de administrador.
6. **Nunca apague** `AGENTS.md`, `SPECS.md`, `README.md`, `.github/workflows/deploy.yml`,
   `assets/` ou `scripts/check.sh`.
7. **`[BLOQUEADO]`** = depende de uma resposta humana. Pule e continue na próxima tarefa.
8. **`[OPCIONAL]`** = se falhar, registre e siga em frente; não bloqueia a entrega.
9. Se um comando falhar **duas vezes**, pare tudo e reporte a saída de erro completa.
10. Trabalhe sempre na branch `main`.

### Legenda

| Marca | Significado |
|---|---|
| `[ ]` | a fazer |
| `[x]` | concluído |
| `[BLOQUEADO]` | precisa de resposta humana |
| `[OPCIONAL]` | não bloqueia a entrega |

---

## 1. Contexto do projeto (fatos — não altere sem instrução)

| Item | Valor |
|---|---|
| Diretório local | `/Users/victorrizzotto/Desktop/site-pessoal` |
| Repositório | `VictorRizzotto/site-pessoal` (público) |
| Branch | `main` |
| URL de produção | `https://victorrizzotto.github.io/site-pessoal/` |
| Base path | `/site-pessoal/` |
| Stack | HTML, CSS e JavaScript puros — sem build, sem dependências |
| Deploy | GitHub Actions → GitHub Pages (`build_type: workflow`) |
| Binário do `gh` | `$HOME/.local/bin/gh` (não está no PATH padrão) |
| Porta local | `8000` |

### Arquivos que existem hoje

```
index.html                       página única
404.html                         página de erro
assets/css/style.css             estilos e temas
assets/js/main.js                comportamento
assets/img/favicon.svg           ícone
.github/workflows/deploy.yml     deploy
scripts/check.sh                 verificações automáticas
AGENTS.md                        regras de trabalho
SPECS.md                         especificação
README.md                        instruções de uso
TODO.md                          este arquivo
```

---

## Fase 0 — Preparação do ambiente

### T0.1 — Entrar no repositório

```sh
cd /Users/victorrizzotto/Desktop/site-pessoal
```

**VERIFICAR**
```sh
pwd
```
**SAÍDA ESPERADA**
```
/Users/victorrizzotto/Desktop/site-pessoal
```
**SE FALHAR:** o diretório não existe. Pare e peça o caminho correto.

---

### T0.2 — Colocar o `gh` no PATH

```sh
export PATH="$HOME/.local/bin:$PATH"
```

**VERIFICAR**
```sh
gh --version | head -1
```
**SAÍDA ESPERADA** (a versão pode variar, o formato não)
```
gh version 2.103.2 (2026-10-23)
```
**SE FALHAR:** rode `ls -l "$HOME/.local/bin/gh"`. Se o arquivo não existir, pare — o deploy
não pode ser feito por este caminho.

> Este `export` vale só para o terminal atual. Repita em todo terminal novo.

---

### T0.3 — Confirmar estado do git

```sh
git status -sb | head -1
git log --oneline -1
```
**SAÍDA ESPERADA**
```
## main...origin/main
<algum hash> <mensagem de commit>
```
Não deve aparecer `ahead`, `behind` nem `diverged`.

**SE FALHAR:**
- Se aparecer `diverged` ou `behind`: rode `git pull --ff-only` e repita.
- Se houver arquivos modificados sem commit: rode `git status` e siga para a Fase 5 antes de
  continuar (commite o que já existe).

---

### T0.4 — Subir o servidor local

```sh
nohup python3 -m http.server 8000 --bind 127.0.0.1 > /tmp/site-servidor.log 2>&1 &
sleep 1
```

**VERIFICAR**
```sh
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8000/
```
**SAÍDA ESPERADA**
```
200
```
**SE FALHAR:**
- Se retornar `000`: rode `cat /tmp/site-servidor.log`. Se disser "Address already in use", rode
  `lsof -ti :8000 | xargs kill` e repita T0.4.

> Para derrubar o servidor no fim de tudo: `lsof -ti :8000 | xargs kill`

---

### T0.5 — Rodar as verificações automáticas

```sh
bash scripts/check.sh
```
**SAÍDA ESPERADA** — a última linha deve ser exatamente:
```
RESULTADO: TUDO OK (5 pendência(s) opcional(is))
```
e o código de saída deve ser `0`. Confirme com:

```sh
bash scripts/check.sh > /dev/null 2>&1; echo "exit=$?"
```
**SAÍDA ESPERADA**
```
exit=0
```

**SE FALHAR:** leia a lista `FALHA` no fim da saída. Cada item indica o arquivo e o problema.
Corrija **apenas** o que a mensagem aponta e rode de novo. Nunca edite o `check.sh` para
esconder uma falha.

> O número de pendências pode mudar conforme as fases avançam. O que importa é `exit=0`.

---

## Fase 1 — Conteúdo que depende de resposta humana

> **Pare aqui e pergunte antes de executar qualquer tarefa desta fase.**
> Nenhuma delas pode ser respondida por dedução.

### T1.1 — [BLOQUEADO] Estado na cidade

Pergunta: **"Escrever `Marau` ou `Marau, RS` no site?"**

Se a resposta for `Marau, RS`, execute:

```sh
sed -i '' 's|<dd>Marau</dd>|<dd>Marau, RS</dd>|' index.html
```

**VERIFICAR**
```sh
grep -c '<dd>Marau, RS</dd>' index.html
```
**SAÍDA ESPERADA**
```
1
```

---

### T1.2 — [BLOQUEADO] Currículo em PDF

Pergunta: **"Existe um currículo em PDF para disponibilizar?"**

Se **não** existir: marque como concluída e siga. Nada muda no site.

Se existir, peça o arquivo e salve exatamente em:

```
assets/cv/victor-rizzotto-curriculo.pdf
```

Depois insira o botão **antes** da linha que contém `<a class="btn btn-primary" href="#contato">Entrar em contato</a>`:

```html
            <a class="btn btn-ghost" href="assets/cv/victor-rizzotto-curriculo.pdf" download>
              Baixar currículo (PDF)
            </a>
```

**VERIFICAR**
```sh
test -f assets/cv/victor-rizzotto-curriculo.pdf && echo "pdf ok"
grep -c 'Baixar currículo' index.html
```
**SAÍDA ESPERADA**
```
pdf ok
1
```

---

### T1.3 — [BLOQUEADO] LinkedIn

Pergunta: **"Qual é a URL completa do seu LinkedIn?"**

Se a resposta for "não tenho", marque como concluída e siga sem alterar nada.

Se houver URL, adicione um item na lista `<ul class="contact-list">` do `index.html`, logo depois
do item do GitHub, copiando exatamente este formato e trocando apenas `URL_AQUI` e `NOME_AQUI`:

```html
            <li>
              <a href="URL_AQUI" class="contact-item" target="_blank" rel="noopener noreferrer">
                <span class="contact-label">LinkedIn</span>
                <span class="contact-value">NOME_AQUI</span>
              </a>
            </li>
```

**VERIFICAR**
```sh
grep -c 'contact-label">LinkedIn' index.html
```
**SAÍDA ESPERADA**
```
1
```

---

## Fase 2 — SEO técnico e publicação de arquivos novos

> Estas tarefas são totalmente executáveis. Nenhuma exige decisão humana.
> **Atenção:** arquivos novos na raiz **não vão para o ar** sem a tarefa T2.5.

### T2.1 — Criar `robots.txt`

Crie o arquivo `robots.txt` na raiz do projeto com **exatamente** este conteúdo:

```
User-agent: *
Allow: /

Sitemap: https://victorrizzotto.github.io/site-pessoal/sitemap.xml
```

**VERIFICAR**
```sh
cat robots.txt
```
**SAÍDA ESPERADA** — 4 linhas, idênticas às acima.

---

### T2.2 — Criar `sitemap.xml`

Crie o arquivo `sitemap.xml` na raiz com **exatamente** este conteúdo:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://victorrizzotto.github.io/site-pessoal/</loc>
    <lastmod>2026-10-23</lastmod>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

> Ao alterar o conteúdo do site no futuro, atualize `<lastmod>` para a data da alteração no
> formato `AAAA-MM-DD`.

**VERIFICAR**
```sh
grep -c '<urlset' sitemap.xml
```
**SAÍDA ESPERADA**
```
1
```

---

### T2.3 — Inserir JSON-LD `Person` no `index.html`

Rode **exatamente** este comando, a partir da raiz do projeto:

```sh
python3 - <<'PY'
from pathlib import Path

p = Path("index.html")
s = p.read_text(encoding="utf-8")

if "application/ld+json" in s:
    print("JA_EXISTE")
else:
    bloco = """    <script type="application/ld+json">
      {
        "@context": "https://schema.org",
        "@type": "Person",
        "name": "Victor Rizzotto",
        "url": "https://victorrizzotto.github.io/site-pessoal/",
        "email": "mailto:victorrizzotto65@gmail.com",
        "jobTitle": "Estudante de Ciência da Computação",
        "affiliation": { "@type": "CollegeOrUniversity", "name": "Atitus" },
        "sameAs": ["https://github.com/VictorRizzotto"],
        "knowsAbout": ["HTML", "CSS", "JavaScript", "React", "TypeScript"]
      }
    </script>
"""
    assert "  </head>" in s, "marcador </head> nao encontrado"
    s = s.replace("  </head>", bloco + "  </head>", 1)
    p.write_text(s, encoding="utf-8")
    print("INSERIDO")
PY
```

**VERIFICAR**
```sh
grep -c '"@type": "Person"' index.html
```
**SAÍDA ESPERADA**
```
1
```
O comando deve ter imprimido `INSERIDO` (ou `JA_EXISTE`, se já rodou antes).

**SE FALHAR:** se aparecer `marcador </head> nao encontrado`, abra o `index.html`, confirme que
existe uma linha `  </head>` (dois espaços de indentação) e rode de novo.

---

### T2.4 — [BLOQUEADO] `og:image` (imagem de compartilhamento)

Pergunta: **"Você tem uma imagem 1200×630 para o link compartilhado?"**

Se **não** houver imagem: marque como concluída e siga. **Não** aponte `og:image` para um
arquivo inexistente — isso piora o resultado.

Se houver, salve como `assets/img/og.png` e insira esta linha no `<head>`, imediatamente após a
linha do `og:locale`:

```html
    <meta property="og:image" content="https://victorrizzotto.github.io/site-pessoal/assets/img/og.png" />
```

**VERIFICAR**
```sh
test -f assets/img/og.png && echo "imagem ok"
grep -c 'property="og:image"' index.html
```
**SAÍDA ESPERADA**
```
imagem ok
1
```

---

### T2.5 — Publicar `robots.txt` e `sitemap.xml` no deploy

O workflow copia para o site **apenas** os arquivos listados em uma linha. Sem este passo, os
dois arquivos criados em T2.1 e T2.2 **não vão para o ar**.

```sh
sed -i '' 's|cp index.html 404.html _site/|cp index.html 404.html robots.txt sitemap.xml _site/|' .github/workflows/deploy.yml
```

**VERIFICAR**
```sh
grep -n 'cp index.html' .github/workflows/deploy.yml
```
**SAÍDA ESPERADA**
```
          cp index.html 404.html robots.txt sitemap.xml _site/
```
**SE FALHAR:** abra `.github/workflows/deploy.yml`, localize a seção `Preparar artefato` e
substitua a linha `cp index.html 404.html _site/` por
`cp index.html 404.html robots.txt sitemap.xml _site/`.

---

### T2.6 — Rodar as verificações de novo

```sh
bash scripts/check.sh | tail -8
```
**SAÍDA ESPERADA** — as pendências de `robots.txt`, `sitemap.xml`, `JSON-LD` e `workflow` devem
ter desaparecido. Só pode restar a pendência de `og:image` (T2.4):

```
RESULTADO: TUDO OK (1 pendência(s) opcional(is))
```

**SE FALHAR:** o `check.sh` lista exatamente o item problemático. Corrija-o e repita.

---

## Fase 3 — Testes automatizados

### T3.1 — Verificações estáticas

```sh
bash scripts/check.sh > /dev/null 2>&1; echo "exit=$?"
```
**SAÍDA ESPERADA**
```
exit=0
```

---

### T3.2 — Status HTTP local

```sh
for p in / /assets/css/style.css /assets/js/main.js /assets/img/favicon.svg /404.html; do
  printf "%-28s " "$p"
  curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1:8000$p"
done
```
**SAÍDA ESPERADA**
```
/                            200
/assets/css/style.css        200
/assets/js/main.js           200
/assets/img/favicon.svg      200
/404.html                    200
```
**SE FALHAR:** um `404` significa arquivo referenciado com caminho errado. Confira o nome exato
do arquivo com `ls`.

---

### T3.3 — Lighthouse (desktop)

Primeiro confirme que existe um navegador Chromium instalado (Chrome, Chromium ou Edge):

```sh
for app in "/Applications/Google Chrome.app" "/Applications/Chromium.app" "/Applications/Microsoft Edge.app"; do
  [ -d "$app" ] && echo "ENCONTRADO: $app"
done
true
```
**SAÍDA ESPERADA** — uma linha `ENCONTRADO: ...`. Se não aparecer nenhuma, pule para o
**Plano B** abaixo.

**Plano A — linha de comando**
```sh
npx --yes lighthouse@12 http://127.0.0.1:8000 \
  --only-categories=performance,accessibility,best-practices,seo \
  --preset=desktop --quiet \
  --output=json --output-path=/tmp/lh.json \
  --chrome-flags="--headless=new"
```

**VERIFICAR**
```sh
python3 - <<'PY'
import json
d = json.load(open("/tmp/lh.json"))
falhou = False
for k, v in d["categories"].items():
    nota = round((v["score"] or 0) * 100)
    status = "OK   " if nota >= 95 else "FALHA"
    if nota < 95:
        falhou = True
    print(f"{status} {k}: {nota}")
print("RESULTADO:", "FALHA" if falhou else "TUDO >= 95")
PY
```
**SAÍDA ESPERADA**
```
OK    performance: <95-100>
OK    accessibility: 100
OK    best-practices: 100
OK    seo: 100
RESULTADO: TUDO >= 95
```

**Plano B — sem Chrome**
Abra o site no navegador, DevTools → aba **Lighthouse** → categoria *Desktop*, todas as
categorias → **Analyze page load**. Critério de aceite: as quatro notas ≥ 95.

**SE FALHAR:** abra `/tmp/lh.json`, procure `"score": 0` e veja `details.items[].node.selector`
para descobrir o elemento. Corrija **apenas** o elemento apontado.

> Notas de Performance variam alguns pontos entre execuções. Só trate como falha abaixo de 95.

---

### T3.4 — Links externos respondendo

```sh
for u in https://empresa-wheat.vercel.app https://github.com/VictorRizzotto; do
  printf "%-42s " "$u"
  curl -s -o /dev/null -L -w "%{http_code}\n" --max-time 20 "$u"
done
```
**SAÍDA ESPERADA**
```
https://empresa-wheat.vercel.app            200
https://github.com/VictorRizzotto           200
```
**SE FALHAR:** `404` no TapHub significa que o deploy do Vercel saiu do ar — **não** remova o
link sem instrução; reporte ao dono do projeto.

---

### T3.5 — Validar que o HTML não tem tags desbalanceadas

```sh
python3 - <<'PY'
from html.parser import HTMLParser

VAZIAS = {"area","base","br","col","embed","hr","img","input","link","meta","param","source","track","wbr"}

class P(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.pilha = []
        self.erros = []
    def handle_starttag(self, tag, attrs):
        if tag not in VAZIAS:
            self.pilha.append(tag)
    def handle_endtag(self, tag):
        if tag in VAZIAS:
            return
        if not self.pilha:
            self.erros.append(f"fechamento sem abertura: </{tag}>")
            return
        if self.pilha[-1] != tag:
            self.erros.append(f"esperado </{self.pilha[-1]}>, encontrado </{tag}>")
            if tag in self.pilha:
                while self.pilha and self.pilha.pop() != tag:
                    pass
            return
        self.pilha.pop()

for arquivo in ("index.html", "404.html"):
    p = P()
    p.feed(open(arquivo, encoding="utf-8").read())
    erros = p.erros + [f"tag nao fechada: <{t}>" for t in p.pilha]
    print(f"{arquivo}: {'OK' if not erros else 'FALHA'}")
    for e in erros:
        print("   ", e)
PY
```
**SAÍDA ESPERADA**
```
index.html: OK
404.html: OK
```
**SE FALHAR:** a mensagem indica o par de tags. Corrija no arquivo apontado e repita.

---

## Fase 4 — Testes manuais (obrigatórios antes de publicar)

> Nesta fase não há comando: é observação no navegador. Cada tarefa tem um critério objetivo.

### T4.1 — Responsivo

Abra `http://127.0.0.1:8000/` e, no DevTools (F12), ative o modo dispositivo (⌘⇧M). Teste as
larguras: **320, 375, 768, 1024, 1440, 2560** px.

Em cada largura, rode no console:

```js
document.documentElement.scrollWidth <= window.innerWidth
```

**CRITÉRIO** — as três condições abaixo, em **todas** as larguras:
1. O console responde `true` (sem rolagem horizontal).
2. O menu vira hambúrguer abaixo de 736 px e os quatro links aparecem ao clicar.
3. Nenhum texto fica sobreposto ou cortado.

**SE FALHAR:** anote a largura e o elemento. Não publique.

---

### T4.2 — Navegação por teclado

Recarregue a página e pressione **Tab** repetidamente, sem usar o mouse.

**ORDEM ESPERADA** (esta, exatamente):
1. "Pular para o conteúdo"
2. Logo (link da marca)
3. Sobre
4. Projetos
5. Experiência
6. Contato
7. Botão de tema
8. "Ver projetos"
9. "Falar comigo"
10. "Visitar o site" (TapHub)
11. "Ver código" (Este site)
12. "Entrar em contato"
13. E-mail
14. GitHub List

**CRITÉRIO**
- Todos os 14 recebem um contorno visível ao focar.
- Nenhum elemento "prende" o foco.
- **Enter** no item 1 leva ao conteúdo principal.
- **Escape** fecha o menu mobile.

**SE FALHAR:** o culpado é quase sempre `outline: none` no CSS. Não publique com foco invisível.

---

### T4.3 — Temas

1. Clique no botão de tema (sol/lua). O site deve alternar entre claro e escuro.
2. Recarregue a página (⌘R). O tema escolhido deve **permanecer**.
3. Abra em uma aba anônima. O tema deve seguir a preferência do sistema operacional.

**CRITÉRIO** — os três passos funcionam.

---

### T4.4 — Console limpo

Com o DevTools aberto, recarregue a página.

**CRITÉRIO**
- Aba **Console**: zero linhas vermelhas.
- Aba **Network**: nenhuma requisição com status `404` ou `500`.

**SE FALHAR:** um `404` indica caminho de arquivo errado. Confirme com `ls assets/`.

---

### T4.5 — Conteúdo e links

Clique em **todos** os links e confirme o destino:

| Link | Destino esperado |
|---|---|
| Sobre / Projetos / Experiência / Contato | rola para a seção correspondente |
| Ver projetos | seção Projetos |
| Falar comigo / Entrar em contato | seção Contato |
| Visitar o site | `https://empresa-wheat.vercel.app` em nova aba |
| Ver código | repositório no GitHub em nova aba |
| E-mail | abre o cliente de e-mail com `victorrizzotto65@gmail.com` |
| GitHub | `https://github.com/VictorRizzotto` em nova aba |

**CRITÉRIO** — nenhum link leva a lugar nenhum ou a uma página de erro.

---

### T4.6 — Conferência de fatos

Leia a página inteira e confirme que **cada** afirmação abaixo está correta. Se alguma estiver
errada, **não publique** — reporte ao dono do projeto.

- [ ] Nome: Victor Rizzotto
- [ ] Curso: Ciência da Computação
- [ ] Instituição: Atitus
- [ ] Previsão de formatura: 2030
- [ ] Cidade: Marau
- [ ] Disponibilidade: estágio, remoto ou híbrido
- [ ] E-mail: victorrizzotto65@gmail.com
- [ ] GitHub: github.com/VictorRizzotto
- [ ] TapHub usou React 19, TypeScript, Tailwind CSS, Supabase e Vercel
- [ ] TapHub está em empresa-wheat.vercel.app

---

## Fase 5 — Publicação

### T5.1 — Revisar o que vai subir

```sh
git status --short
```
**SAÍDA ESPERADA** — apenas arquivos que você alterou nesta execução
(`robots.txt`, `sitemap.xml`, `index.html`, `.github/workflows/deploy.yml`, etc.).

**SE FALHAR:** se aparecer `.DS_Store`, rode `rm -f .DS_Store` e repita. Se aparecer arquivo que
você não reconhece, **pare** e pergunte antes de commitar.

---

### T5.2 — Rodar o check uma última vez

```sh
bash scripts/check.sh | tail -3
```
**SAÍDA ESPERADA**
```
RESULTADO: TUDO OK (N pendência(s) opcional(is))
```
onde `N` é `0` ou `1` (só `og:image` pode restar).

**SE FALHAR:** não commite. Volte à fase indicada pela mensagem.

---

### T5.3 — Commit e push

```sh
git add -A
git commit -m "feat: adiciona robots.txt, sitemap.xml e JSON-LD"
git push origin main
```
**SAÍDA ESPERADA**
```
To https://github.com/VictorRizzotto/site-pessoal.git
   <hash>..<hash>  main -> main
```

**SE FALHAR:**
- `Authentication failed` → rode `export PATH="$HOME/.local/bin:$PATH"` e tente de novo.
- `! [rejected]` → rode `git pull --ff-only` e repita o push.

---

### T5.4 — Acompanhar o deploy

```sh
sleep 10
RUN=$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$RUN" --exit-status --interval 5 | tail -12
```
**SAÍDA ESPERADA** — todas as etapas com `✓`, terminando em:
```
✓ deploy in <N>s
✓ Complete job
```
O código de saída deve ser `0`.

**SE FALHAR:** rode `gh run view "$RUN" --log-failed | tail -40` e leia o erro. As causas comuns
estão no Apêndice B.

---

### T5.5 — Validar a produção

```sh
echo "--- home ---"
curl -s -o /dev/null -w "%{http_code}\n" https://victorrizzotto.github.io/site-pessoal/

echo "--- title ---"
curl -s https://victorrizzotto.github.io/site-pessoal/ | grep -o '<title>[^<]*</title>'

echo "--- robots ---"
curl -s https://victorrizzotto.github.io/site-pessoal/robots.txt | head -1

echo "--- sitemap ---"
curl -s -o /dev/null -w "%{http_code}\n" https://victorrizzotto.github.io/site-pessoal/sitemap.xml

echo "--- 404 ---"
curl -s -o /dev/null -w "%{http_code}\n" https://victorrizzotto.github.io/site-pessoal/pagina-inexistente

echo "--- json-ld ---"
curl -s https://victorrizzotto.github.io/site-pessoal/ | grep -c '"@type": "Person"'
```

**SAÍDA ESPERADA**
```
--- home ---
200
--- title ---
<title>Victor Rizzotto — Desenvolvedor web em formação</title>
--- robots ---
User-agent: *
--- sitemap ---
200
--- 404 ---
404
--- json-ld ---
1
```

**SE FALHAR:**
- `404` em `robots.txt` ou `sitemap.xml` → a tarefa T2.5 não foi aplicada. Volte, corrija e
  faça um novo commit.
- `0` no json-ld → T2.3 não foi aplicada.
- `404` na home → o deploy falhou; volte a T5.4.

> A propagação do GitHub Pages pode levar até 60 s. Se a home retornar `404`, espere 30 s e
> repita **uma vez** antes de tratar como falha.

---

### T5.6 — Rollback (só se a produção quebrar)

```sh
git revert --no-edit HEAD
git push origin main
```
Isso cria um commit que desfaz o anterior e dispara um novo deploy.

---

## Fase 6 — Manutenção (executar só quando pedido)

### T6.1 — Adicionar um projeto novo

No `index.html`, dentro de `<ul class="cards">`, copie o bloco abaixo e substitua **apenas** os
valores em maiúsculas:

```html
            <li class="card">
              <div class="card-top">
                <p class="card-tag">CATEGORIA</p>
                <h3 class="card-title">NOME DO PROJETO</h3>
              </div>
              <p class="card-text">
                O QUE O PROJETO FAZ, QUAL PROBLEMA RESOLVE E O QUE VOCÊ CONSTRUIU NELE.
              </p>
              <ul class="chips" aria-label="Tecnologias do projeto">
                <li>TECNOLOGIA 1</li>
                <li>TECNOLOGIA 2</li>
              </ul>
              <a class="card-link" href="URL_DO_PROJETO" target="_blank" rel="noopener noreferrer">
                Visitar o site
                <svg viewBox="0 0 16 16" aria-hidden="true" focusable="false">
                  <path d="M4 12 12 4M6 4h6v6" />
                </svg>
                <span class="sr-only">(abre em nova aba)</span>
              </a>
            </li>
```

**VERIFICAR**
```sh
bash scripts/check.sh > /dev/null 2>&1; echo "exit=$?"
```
**SAÍDA ESPERADA**
```
exit=0
```

---

### T6.2 — Trocar as cores do site

Edite `assets/css/style.css`. Há **dois** blocos de tokens: um para tema claro (`:root`) e um
para tema escuro (`:root[data-theme="dark"]` e o `@media (prefers-color-scheme: dark)`).

Altere **nos dois**:

```css
--accent: #4f46e5;   /* cor principal  */
--accent-2: #0ea5e9; /* cor secundária */
```

**VERIFICAR** — o contraste continua válido. Rode T3.3 (Lighthouse) e confirme *accessibility: 100*.

---

### T6.3 — Renomear o repositório

Se o repositório mudar de nome, **todos** os pontos abaixo precisam ser atualizados. Só execute
com a confirmação do novo nome (`NOVO-NOME`).

1. `404.html` → `<base href="/site-pessoal/">` passa a `<base href="/NOVO-NOME/">`
2. `index.html` → `rel="canonical"` e `og:url`
3. `index.html` → JSON-LD `"url"`
4. `robots.txt` → linha `Sitemap:`
5. `sitemap.xml` → `<loc>`
6. `README.md` → menções à URL
7. `SPECS.md` → menções à URL

**VERIFICAR**
```sh
grep -rn "site-pessoal" --include='*.html' --include='*.txt' --include='*.xml' --include='*.md' . | grep -v TODO.md
```
**SAÍDA ESPERADA** — nenhuma linha (vazio).

---

## Apêndice A — Comandos de referência

```sh
# entrar no projeto
cd /Users/victorrizzotto/Desktop/site-pessoal

# habilitar gh
export PATH="$HOME/.local/bin:$PATH"

# servidor local
python3 -m http.server 8000 --bind 127.0.0.1

# derrubar servidor
lsof -ti :8000 | xargs kill

# verificações automáticas
bash scripts/check.sh

# estado do repositório
git status -sb

# últimos deploys
gh run list --limit 5

# ver log de um deploy que falhou
gh run view --log-failed

# URL de produção
open https://victorrizzotto.github.io/site-pessoal/
```

---

## Apêndice B — Problemas comuns

| Sintoma | Causa provável | Ação |
|---|---|---|
| `gh: command not found` | PATH não exportado | `export PATH="$HOME/.local/bin:$PATH"` |
| `Resource not accessible by integration` | token sem escopo `repo` | `export PATH=...` e rode `gh auth status`; se não estiver logado, `gh auth login --web -s repo,read:org,workflow,gist` |
| Deploy falha em `Configurar Pages` | Pages não habilitado | `gh api -X POST /repos/VictorRizzotto/site-pessoal/pages -f build_type=workflow` |
| `robots.txt` retorna 404 em produção | workflow não copia o arquivo | refazer T2.5 e commitar |
| Site antigo no ar após push | cache/CDN | esperar 60 s e recarregar com ⌘⇧R |
| `Address already in use` na porta 8000 | servidor já rodando | `lsof -ti :8000 \| xargs kill` |
| Lighthouse < 95 em Performance | concorrência na máquina | feche outras abas/apps e rode de novo; só trate como falha se repetir |
| Acentuação quebrada em produção | arquivo salvo sem UTF-8 | confirmar `<meta charset="utf-8">` e salvar em UTF-8 |

---

## Apêndice C — Definição de pronto

A execução só está concluída quando **todos** os itens forem verdadeiros:

- [ ] `bash scripts/check.sh` termina com `exit=0`
- [ ] T3.2 retorna `200` nos cinco caminhos
- [ ] Lighthouse ≥ 95 nas quatro categorias
- [ ] T4.1 a T4.6 conferidos no navegador
- [ ] `git status` limpo após o push
- [ ] Workflow de deploy verde
- [ ] Produção responde `200`, com `robots.txt`, `sitemap.xml`, JSON-LD e 404 funcionando
- [ ] `SPECS.md` e `README.md` atualizados se algo de produto mudou

---

## Apêndice D — O que nunca fazer

- Nunca apontar `og:image` para arquivo inexistente.
- Nunca remover o `<base href>` do `404.html`.
- Nunca remover `prefers-reduced-motion` ou o `skip-link`.
- Nunca trocar `target="_blank"` por `target="_new"` (ou remover o `rel="noopener noreferrer"`).
- Nunca adicionar `!important` fora do bloco `prefers-reduced-motion`.
- Nunca adicionar dependência, framework, bundler ou CDN.
- Nunca commitar `.DS_Store`, `node_modules`, tokens ou arquivos `.env`.
- Nunca alterar textos do site sem confirmação do dono do projeto.
- Nunca editar `scripts/check.sh` para fazer uma falha desaparecer.
