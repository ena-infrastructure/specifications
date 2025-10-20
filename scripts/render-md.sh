#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: render_md.sh <input.md> <target-dir>

Renders GitHub-flavoured Markdown (GFM) to HTML using `gh api`,
wraps it in a GitHub-like template (light theme forced, Mermaid enabled),
and writes to:
  <cwd>/<target-dir>/<input-basename-with-spaces>_.html

Also copies the images directory located at:
  <script_dir>/../images
into the output directory (recursively), if it exists.

Env options:
  GFM_CONTEXT=owner/repo   # optional: resolve #123, @user like on GitHub
  MARKDOWN_CSS_URL=...     # optional: override stylesheet URL
  STRIP_MERMAID_LANG=1     # default=1: send fences as ``` (no lang) to avoid highlight wrappers
USAGE
}

if [[ $# -ne 2 ]]; then usage; exit 1; fi

INPUT_ARG="$1"
OUT_DIR_ARG="$2"

# Where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve path relative to CWD unless absolute
resolve_cwd_path() {
  local p="$1"
  if [[ "$p" = /* ]]; then printf '%s\n' "$p"; else
    local d b
    d="$(cd "$(dirname "$p")" && pwd)"
    b="$(basename "$p")"
    printf '%s/%s\n' "$d" "$b"
  fi
}

INPUT_ABS="$(resolve_cwd_path "$INPUT_ARG")"
if [[ "$OUT_DIR_ARG" = /* ]]; then OUT_DIR_ABS="$OUT_DIR_ARG"; else OUT_DIR_ABS="$(pwd)/$OUT_DIR_ARG"; fi

command -v gh >/dev/null 2>&1 || { echo "Error: gh CLI required."; exit 1; }
[[ -f "$INPUT_ABS" ]] || { echo "Error: input file not found: $INPUT_ABS" >&2; exit 1; }

mkdir -p "$OUT_DIR_ABS"

in_base="$(basename "$INPUT_ABS")"
in_stem="${in_base%.*}"
safe_stem="${in_stem//[[:space:]]/_}"
OUTPUT_ABS="$OUT_DIR_ABS/$safe_stem.html"

CSS_URL_DEFAULT="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown-light.min.css"
CSS_URL="${MARKDOWN_CSS_URL:-$CSS_URL_DEFAULT}"

TMP_CONTENT="$(mktemp)"; TMP_MD=""; cleanup(){ rm -f "$TMP_CONTENT" ${TMP_MD:-}; }; trap cleanup EXIT

# Optional: strip ```mermaid -> ``` to reduce <div class="highlight-source-mermaid"> wrappers
PRE_MD="$INPUT_ABS"
if [[ "${STRIP_MERMAID_LANG:-1}" == "1" ]]; then
  TMP_MD="$(mktemp)"
  awk '(/^```[[:space:]]*mermaid(\{.*\})?[[:space:]]*$/){print "```"; next} {print}' "$INPUT_ABS" > "$TMP_MD"
  PRE_MD="$TMP_MD"
fi

# Render via GitHub Markdown API
if [[ -n "${GFM_CONTEXT:-}" ]]; then
  gh api markdown -F mode=gfm -F "context=$GFM_CONTEXT" -F "text=@$PRE_MD" > "$TMP_CONTENT"
else
  gh api markdown -F mode=gfm -F "text=@$PRE_MD" > "$TMP_CONTENT"
fi

# HTML shell
cat > "$OUTPUT_ABS" <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${in_base}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="color-scheme" content="light">
  <link rel="stylesheet" href="$CSS_URL">
  <style>
    :root { color-scheme: light; }
    html, body { background: #ffffff !important; }
    .markdown-body {
      color: #24292f !important;
      background: #ffffff !important;
      box-sizing: border-box;
      min-width: 200px;
      max-width: 1080px;
      margin: 0 auto;
      padding: 45px;
    }
    .markdown-body .mermaid,
    .markdown-body .mermaid svg { background: #ffffff !important; }
    .markdown-body pre, .markdown-body code, .markdown-body tt {
      background: #f6f8fa !important; color: #24292f !important;
    }
    .markdown-body table tr { background: #ffffff !important; }
    .markdown-body blockquote { color: #57606a !important; background: #ffffff !important; }
    @media (max-width: 767px) { .markdown-body { padding: 15px; } }
  </style>
</head>
<body>
  <article class="markdown-body">
EOF

cat "$TMP_CONTENT" >> "$OUTPUT_ABS"

cat >> "$OUTPUT_ABS" <<'EOF'
  </article>

  <!-- Mermaid runtime -->
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>

  <script>
    // ---- 1) Normalize GitHub "user-content-" anchors so #introduction works ----
    (function normalizeAnchors() {
      // For <a name="user-content-foo"> → add id="foo" on that <a>
      document.querySelectorAll('a[name^="user-content-"]').forEach(function(a){
        var name = a.getAttribute('name');
        if (!name) return;
        var plain = name.replace(/^user-content-/, '');
        // Add an id alias (safe even if duplicates; we check)
        if (!document.getElementById(plain)) a.id = plain;
      });

      // For any element with id="user-content-foo" → insert alias <span id="foo">
      document.querySelectorAll('[id^="user-content-"]').forEach(function(el){
        var plain = el.id.replace(/^user-content-/, '');
        if (!document.getElementById(plain)) {
          var alias = document.createElement('span');
          alias.id = plain;
          alias.style.position = 'relative';
          alias.style.top = '-0px'; // no offset; adjust if you add fixed headers
          el.prepend(alias);
        }
      });
    })();

    // ---- 2) Robust Mermaid detection and manual render ----
    (async function () {
      function isMermaidFirstLine(s) {
        if (!s) return false;
        var first = (s || '').split('\n').find(function (ln) { return ln.trim().length > 0; }) || '';
        first = first.trim();
        return /^(graph(?![a-z])|flowchart|sequenceDiagram|classDiagram|erDiagram|stateDiagram|journey|gantt|pie|mindmap|timeline|quadrantChart)\b/.test(first);
      }

      // GitHub style: <div class="highlight highlight-source-mermaid"><pre>…</pre></div>
      var preGH = Array.from(document.querySelectorAll('div.highlight-source-mermaid > pre'));
      // Classic: <pre><code class="language-mermaid">…</code></pre> or inline code
      var codeClassic = Array.from(document.querySelectorAll('pre > code.language-mermaid, code.language-mermaid, code.mermaid'));
      // Fallback: any <pre> whose first non-empty line looks like Mermaid
      var preLooksLike = Array.from(document.querySelectorAll('pre')).filter(function (pre) {
        if (pre.closest('div.highlight-source-mermaid')) return false;
        return isMermaidFirstLine(pre.textContent || '');
      });

      var candidates = [].concat(preGH, codeClassic, preLooksLike);

      var containers = [];
      candidates.forEach(function (node) {
        var host, raw;
        if (node.tagName && node.tagName.toLowerCase() === 'pre') {
          host = node;
          raw = node.textContent || '';
        } else if (node.tagName && node.tagName.toLowerCase() === 'code') {
          host = node.closest('pre') || node;
          raw = node.textContent || '';
        } else {
          return;
        }
        var div = document.createElement('div');
        div.className = 'mermaid';
        div.setAttribute('data-raw', raw);
        div.textContent = raw;
        host.replaceWith(div);
        containers.push(div);
      });

      if (containers.length === 0) {
        console.warn('Mermaid: no diagrams detected.');
        return;
      }

      try {
        mermaid.initialize({
          startOnLoad: false,
          theme: 'default',
          securityLevel: 'loose', // allow <br /> in labels
          themeVariables: { background: '#ffffff' }
        });

        let i = 0;
        for (const el of containers) {
          const code = el.getAttribute('data-raw') || '';
          const id = 'mmd-' + (i++);
          try {
            const out = await mermaid.render(id, code);
            el.innerHTML = out.svg;
            if (typeof out.bindFunctions === 'function') out.bindFunctions(el);
          } catch (err) {
            console.error('Mermaid render failed:', err, '\nCode:\n' + code);
          }
        }
        console.log('Mermaid: rendered ' + containers.length + ' diagram(s).');
      } catch (e) {
        console.error('Mermaid init failed:', e);
      }
    })();
  </script>
</body>
</html>
EOF

# Copy images directory from <script_dir>/../images to the output directory
IMAGES_SRC="$SCRIPT_DIR/../images"
if [[ -d "$IMAGES_SRC" ]]; then
  cp -a "$IMAGES_SRC" "$OUT_DIR_ABS/"
  echo "📁 Copied images: $IMAGES_SRC -> $OUT_DIR_ABS/$(basename "$IMAGES_SRC")"
else
  echo "ℹ️ No images directory found at: $IMAGES_SRC (skip copy)"
fi

echo "✅ Rendered HTML written to: $OUTPUT_ABS"
