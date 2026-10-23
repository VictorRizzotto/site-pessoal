#!/usr/bin/env bash
# Verificações determinísticas do site pessoal.
# Uso: bash scripts/check.sh
# Saída: lista de OK/FALHA e código de saída 0 (tudo ok) ou 1 (alguma falha).

set -u

cd "$(dirname "$0")/.." || exit 1

FAIL=0
ERRORS=()

ok() { printf '  OK    %s\n' "$1"; }
fail() {
  printf '  FALHA %s\n' "$1"
  FAIL=$((FAIL + 1))
  ERRORS+=("$1")
}
section() { printf '\n%s\n' "$1"; }

# ---------------------------------------------------------------- arquivos
section "[1/9] Arquivos obrigatórios"

for f in index.html 404.html \
         assets/css/style.css assets/js/main.js assets/img/favicon.svg \
         .github/workflows/deploy.yml AGENTS.md SPECS.md README.md; do
  if [ -f "$f" ]; then ok "$f"; else fail "$f ausente"; fi
done

# ---------------------------------------------------------------- HTML base
section "[2/9] Estrutura do index.html"

grep -q '<html lang="pt-BR">' index.html && ok 'lang="pt-BR"' || fail 'lang="pt-BR" ausente'

H1=$(grep -o '<h1' index.html | wc -l | tr -d ' ')
if [ "$H1" = "1" ]; then ok "exatamente 1 <h1>"; else fail "esperado 1 <h1>, encontrado $H1"; fi

grep -q '<title>' index.html && ok "title presente" || fail "title ausente"
grep -q 'name="description"' index.html && ok "meta description" || fail "meta description ausente"
grep -q 'rel="canonical"' index.html && ok "canonical" || fail "canonical ausente"

for prop in og:type og:title og:description og:url og:locale; do
  if grep -q "property=\"$prop\"" index.html; then
    ok "Open Graph $prop"
  else
    fail "Open Graph $prop ausente"
  fi
done

grep -q 'name="viewport"' index.html && ok "viewport" || fail "viewport ausente"

# ---------------------------------------------------------------- acessibilidade
section "[3/9] Acessibilidade estática"

if grep -q 'class="skip-link"' index.html; then ok "skip link"; else fail "skip link ausente"; fi
grep -q ':focus-visible' assets/css/style.css && ok "estilo de foco visível" || fail ":focus-visible ausente no CSS"
grep -q 'prefers-reduced-motion' assets/css/style.css && ok "prefers-reduced-motion" || fail "prefers-reduced-motion ausente"

# todo <img> precisa do atributo alt
IMG_TOTAL=$(grep -o '<img' index.html | wc -l | tr -d ' ')
IMG_ALT=$(grep -o '<img[^>]*alt=' index.html | wc -l | tr -d ' ')
if [ "$IMG_TOTAL" = "$IMG_ALT" ]; then
  ok "todas as $IMG_TOTAL tags <img> têm alt"
else
  fail "$IMG_TOTAL <img> mas apenas $IMG_ALT com alt"
fi

# target="_blank" sempre com rel de segurança
BLANK=$(grep -o 'target="_blank"' index.html | wc -l | tr -d ' ')
NOOPENER=$(grep -o 'rel="noopener noreferrer"' index.html | wc -l | tr -d ' ')
if [ "$NOOPENER" -ge "$BLANK" ]; then
  ok "links externos com rel=noopener ($BLANK)"
else
  fail "$BLANK target=_blank mas apenas $NOOPENER com rel=noopener noreferrer"
fi

# ---------------------------------------------------------------- conteúdo
section "[4/9] Conteúdo sem placeholder"

if grep -Eiq 'lorem ipsum|a definir|texto de exemplo|placeholder' index.html 404.html; then
  fail "placeholder encontrado em index.html ou 404.html"
else
  ok "sem placeholders"
fi

if grep -q 'TODO' index.html; then fail "TODO esquecido no HTML"; else ok "sem TODO no HTML"; fi

# ---------------------------------------------------------------- âncoras
section "[5/9] Links internos"

for anchor in $(grep -o 'href="#[a-z-]*"' index.html | sed 's/href="#//; s/"//' | sort -u); do
  if grep -q "id=\"$anchor\"" index.html; then
    ok "âncora #$anchor"
  else
    fail "âncora #$anchor sem destino"
  fi
done

# ---------------------------------------------------------------- assets
section "[6/9] Arquivos referenciados"

for ref in $(grep -oE '(src|href)="(assets/[^"]+)"' index.html 404.html | sed 's/.*="//; s/"//' | sort -u); do
  if [ -f "$ref" ]; then ok "$ref"; else fail "$ref referenciado mas não existe"; fi
done

if grep -q 'http://' index.html; then
  fail "link http:// inseguro encontrado"
else
  ok "nenhum link http://"
fi

# ---------------------------------------------------------------- css
section "[7/9] CSS"

if grep -n '!important' assets/css/style.css | grep -vqE 'animation-|transition-'; then
  grep -n '!important' assets/css/style.css | grep -vE 'animation-|transition-'
  fail "!important fora do bloco de prefers-reduced-motion"
else
  ok "sem !important indevido (apenas no prefers-reduced-motion)"
fi

grep -q -- '--accent:' assets/css/style.css && ok "tokens de cor definidos" || fail "token --accent ausente"

# ---------------------------------------------------------------- peso
section "[8/9] Orçamento de peso"

SIZE=$(wc -c index.html assets/css/style.css assets/js/main.js | tail -1 | awk '{print $1}')
LIMIT=102400
if [ "$SIZE" -lt "$LIMIT" ]; then
  ok "HTML+CSS+JS = ${SIZE} bytes (limite ${LIMIT})"
else
  fail "HTML+CSS+JS = ${SIZE} bytes, acima do limite de ${LIMIT}"
fi

# ---------------------------------------------------------------- deploy
section "[9/9] Deploy"

grep -q 'actions/deploy-pages' .github/workflows/deploy.yml && ok "workflow usa deploy-pages" || fail "deploy-pages ausente no workflow"
grep -q 'branches: \[main\]' .github/workflows/deploy.yml && ok "workflow dispara em main" || fail "workflow não dispara em main"

if grep -q 'base href="/site-pessoal/"' 404.html; then
  ok "404.html com base href do repositório"
else
  fail "404.html sem <base href=\"/site-pessoal/\">"
fi

# ---------------------------------------------------------------- segredos
section "[extra] Segredos"

if grep -rEq 'gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}' --include='*.html' --include='*.css' --include='*.js' --include='*.md' .; then
  fail "possível token/segredo commitado"
else
  ok "nenhum token aparente"
fi

# ---------------------------------------------------------------- pendências
section "[extra] Pendências opcionais (não quebram o build)"

PENDING=0
pend() { printf '  PEND  %s\n' "$1"; PENDING=$((PENDING + 1)); }

if [ -f robots.txt ]; then
  grep -q 'Sitemap:' robots.txt && ok "robots.txt aponta para o sitemap" || fail "robots.txt sem linha Sitemap:"
else
  pend "robots.txt (tarefa T2.1 do TODO.md)"
fi

if [ -f sitemap.xml ]; then
  grep -q '<urlset' sitemap.xml && ok "sitemap.xml presente" || fail "sitemap.xml inválido"
else
  pend "sitemap.xml (tarefa T2.2 do TODO.md)"
fi

if grep -q 'application/ld+json' index.html; then
  ok "JSON-LD presente"
else
  pend "JSON-LD Person (tarefa T2.3 do TODO.md)"
fi

if grep -q 'property="og:image"' index.html; then
  ok "og:image presente"
else
  pend "og:image (tarefa T2.4 do TODO.md)"
fi

if grep -q 'robots.txt' .github/workflows/deploy.yml; then
  ok "workflow publica robots.txt/sitemap.xml"
else
  pend "workflow ainda não copia robots.txt e sitemap.xml (tarefa T2.5 do TODO.md)"
fi

# ---------------------------------------------------------------- resumo
echo
if [ "$FAIL" -eq 0 ]; then
  echo "RESULTADO: TUDO OK${PENDING:+ ($PENDING pendência(s) opcional(is))}"
  exit 0
fi

echo "RESULTADO: $FAIL FALHA(S)"
for e in "${ERRORS[@]}"; do echo "  - $e"; done
exit 1
