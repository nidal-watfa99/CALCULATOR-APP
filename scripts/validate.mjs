// Quick sanity checks run by GitHub Actions before deploying (no dependencies).
import fs from 'node:fs';
import vm from 'node:vm';
let bad = 0;
const fail = m => { console.error('✗ ' + m); bad++; };
const ok = m => console.log('✓ ' + m);

const html = fs.readFileSync('index.html', 'utf8');
const a = html.indexOf('<script>') + 8, b = html.lastIndexOf('</script>');
try { new vm.Script(html.slice(a, b), { filename: 'index.html<script>' }); ok('index.html script syntax'); }
catch (e) { fail('script syntax: ' + e.message); }

const code = html.slice(a, b);
if (/\?\?|\?\.(?!\d)/.test(code.replace(/'[^'\n]*'|"[^"\n]*"|`[^`]*`/g, ''))) fail('uses ?? or ?. (breaks older browsers)'); else ok('no ?? / ?. syntax (older-browser safe)');
let man;
try { man = JSON.parse(fs.readFileSync('manifest.webmanifest', 'utf8')); ok('manifest.webmanifest is valid JSON'); }
catch (e) { fail('manifest: ' + e.message); }

if (man) {
  for (const i of man.icons || []) fs.existsSync(i.src) ? ok('icon ' + i.src) : fail('missing icon ' + i.src);
  if (!man.icons?.some(i => i.purpose === 'maskable')) fail('no maskable icon');
}
for (const f of ['sw.js', 'favicon.ico', 'apple-touch-icon.png', 'icon.svg'])
  fs.existsSync(f) ? ok('file ' + f) : fail('missing ' + f);

const sw = fs.readFileSync('sw.js', 'utf8');
for (const m of sw.matchAll(/'([^']+\.(?:png|svg|ico|webmanifest|html))'/g))
  fs.existsSync(m[1]) ? 0 : fail('sw.js caches missing file ' + m[1]);

process.exit(bad ? 1 : 0);
