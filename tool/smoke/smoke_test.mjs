// Boots the built site in headless Chromium and fails if Flutter does not
// mount, if anything throws, or if the resume download would 404.
//
//   BASE_URL=http://127.0.0.1:8080 node smoke_test.mjs
//
// Optional: CHROMIUM_PATH to use a preinstalled browser, SCREENSHOT_DIR to
// save desktop/mobile screenshots for review, ALLOW_ERROR_PATTERN (a regex)
// to ignore console errors caused by the environment rather than the app,
// e.g. a TLS-intercepting proxy in a sandbox. CI does not set it.
// REQUIRE_SKWASM=1 additionally fails unless the page is cross-origin isolated
// and running the Wasm (skwasm) renderer — i.e. the fast path is really on.
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { chromium } from 'playwright';

const baseUrl = (process.env.BASE_URL ?? 'http://127.0.0.1:8080').replace(/\/$/, '');
const screenshotDir = process.env.SCREENSHOT_DIR;
const requireSkwasm = process.env.REQUIRE_SKWASM === '1';
const allowedError = process.env.ALLOW_ERROR_PATTERN
  ? new RegExp(process.env.ALLOW_ERROR_PATTERN)
  : null;
const resumePath = '/assets/assets/Favad_Thottathil_Resume.pdf';
const viewports = [
  { name: 'desktop', width: 1440, height: 900 },
  { name: 'mobile', width: 390, height: 844 },
];

const failures = [];
const fail = (msg) => {
  failures.push(msg);
  console.error(`✗ ${msg}`);
};
const pass = (msg) => console.log(`✓ ${msg}`);

const browser = await chromium.launch({
  executablePath: process.env.CHROMIUM_PATH || undefined,
});

try {
  for (const viewport of viewports) {
    const page = await browser.newPage({ viewport });
    const errors = [];
    const requested = [];
    page.on('request', (r) => requested.push(new URL(r.url()).pathname));
    const record = (msg) => !allowedError?.test(msg) && errors.push(msg);
    page.on('pageerror', (e) => record(e.message));
    page.on('console', (m) => m.type() === 'error' && record(m.text()));

    const response = await page.goto(`${baseUrl}/`, { waitUntil: 'load' });
    if (!response?.ok()) {
      fail(`[${viewport.name}] GET / returned ${response?.status()}`);
      await page.close();
      continue;
    }

    try {
      // Flutter's embedder mounts <flutter-view> once the engine is running.
      await page.waitForSelector('flutter-view', { state: 'attached', timeout: 30_000 });
      // Let the first frames render so late startup errors surface.
      await page.waitForTimeout(3_000);
      pass(`[${viewport.name}] Flutter app mounted`);
    } catch {
      fail(`[${viewport.name}] <flutter-view> never appeared within 30s`);
    }

    const isolated = await page.evaluate(() => window.crossOriginIsolated);
    const renderer = requested.some((p) => p.endsWith('/skwasm.wasm'))
      ? 'skwasm'
      : requested.some((p) => p.endsWith('/canvaskit.wasm'))
        ? 'canvaskit'
        : 'unknown';
    const rendererInfo = `renderer=${renderer}, crossOriginIsolated=${isolated}`;
    if (requireSkwasm && (renderer !== 'skwasm' || !isolated)) {
      fail(`[${viewport.name}] expected multi-threaded skwasm, got ${rendererInfo}`);
    } else {
      pass(`[${viewport.name}] ${rendererInfo}`);
    }

    if (errors.length) {
      fail(`[${viewport.name}] console/page errors:\n  ${errors.join('\n  ')}`);
    } else {
      pass(`[${viewport.name}] no console or page errors`);
    }

    if (screenshotDir) {
      mkdirSync(screenshotDir, { recursive: true });
      await page.screenshot({ path: join(screenshotDir, `${viewport.name}.png`) });
    }
    await page.close();
  }

  const pdf = await fetch(`${baseUrl}${resumePath}`);
  const type = pdf.headers.get('content-type') ?? '';
  if (pdf.ok && type.includes('pdf')) {
    pass(`resume served at ${resumePath} (${type})`);
  } else {
    fail(`resume at ${resumePath} returned ${pdf.status} (${type})`);
  }
} finally {
  await browser.close();
}

if (failures.length) {
  console.error(`\n${failures.length} smoke check(s) failed.`);
  process.exit(1);
}
console.log('\nAll smoke checks passed.');
