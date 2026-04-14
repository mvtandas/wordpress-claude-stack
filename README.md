# wordpress-claude-stack

<p align="center">
  <img src="https://img.shields.io/badge/WordPress-21759B?style=for-the-badge&logo=wordpress&logoColor=white" />
  <img src="https://img.shields.io/badge/WooCommerce-96588A?style=for-the-badge&logo=woocommerce&logoColor=white" />
  <img src="https://img.shields.io/badge/PHP_8.2+-777BB4?style=for-the-badge&logo=php&logoColor=white" />
  <img src="https://img.shields.io/badge/Claude_Code-D97757?style=for-the-badge&logo=anthropic&logoColor=white" />
  <img src="https://img.shields.io/badge/Cursor-000?style=for-the-badge&logo=cursor&logoColor=white" />
</p>

<p align="center">
  <b>Drop-in AI coding setup for WordPress developers.</b><br/>
  CLAUDE.md + .cursorrules + Copilot instructions + 5 generation skills.
</p>

---

## The Problem

Without project rules, AI tools generate WordPress code that:
- Skips `esc_html()` and sanitization — **security vulnerabilities**
- Uses `query_posts()` instead of `WP_Query`
- Writes raw SQL without `$wpdb->prepare()`
- Forgets nonce verification on forms
- Puts business logic in templates
- Generates outdated patterns (pre-Gutenberg, pre-HPOS)

## The Fix

Drop these files in your project. AI tools immediately write **secure, modern WordPress code**.

## What's Inside

| File | For | What it does |
|------|-----|-------------|
| `CLAUDE.md` | Claude Code | Full WordPress conventions — security, hooks, theme/plugin structure |
| `.cursorrules` | Cursor IDE | AI behavior rules for WordPress/PHP |
| `.github/copilot-instructions.md` | GitHub Copilot | Code generation guidelines |
| `skills/generate-plugin.md` | Claude Code | `/generate-plugin my-plugin` |
| `skills/generate-cpt.md` | Claude Code | `/generate-cpt portfolio` |
| `skills/generate-block.md` | Claude Code | `/generate-block hero-banner` |
| `skills/generate-rest-api.md` | Claude Code | `/generate-rest-api products` |
| `skills/generate-woo-extension.md` | Claude Code | `/generate-woo-extension product-tab` |
| `skills/security-check.md` | Claude Code | `/security-check` — audit code for vulnerabilities |
| `SECURITY_CHECKLIST.md` | Reference | Escaping, sanitization, nonces, capabilities checklist |
| `templates/` | Reference | Ready-to-use plugin header & block.json templates |
| `scripts/setup.sh` | Shell | One-command installation |

## Quick Start

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/scripts/setup.sh | bash
```

### Or manually

```bash
# Everything
npx degit mvtandas/wordpress-claude-stack ai-config
cp -r ai-config/{CLAUDE.md,.cursorrules,.github,skills} .

# Or just what you need
curl -o CLAUDE.md https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/CLAUDE.md
curl -o .cursorrules https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/.cursorrules
```

## Generation Skills

```bash
# Generate a complete plugin skeleton
/generate-plugin my-plugin --name "My Plugin"

# Generate Custom Post Type with fields
/generate-cpt portfolio --taxonomies "category" --fields "url, client, year"

# Generate Gutenberg block
/generate-block hero-banner --attributes "title, subtitle, backgroundImage"

# Generate REST API endpoints
/generate-rest-api products --methods "get, post, put, delete"

# Generate WooCommerce extension
/generate-woo-extension product-tab --name "Specs" --fields "weight, material"
```

## Before & After

**Before** (no config):
```php
function get_products() {
    global $wpdb;
    $results = $wpdb->get_results("SELECT * FROM wp_posts WHERE post_type = 'product'");
    foreach ($results as $r) {
        echo $r->post_title;
        echo $_GET['filter'];
    }
}
```

**After** (with wordpress-claude-stack):
```php
declare(strict_types=1);

function mytheme_get_products(string $filter = ''): WP_Query {
    return new WP_Query([
        'post_type'      => 'product',
        'posts_per_page' => 12,
        'meta_query'     => $filter ? [
            ['key' => '_product_filter', 'value' => sanitize_text_field($filter)],
        ] : [],
    ]);
}

// In template:
$products = mytheme_get_products(sanitize_text_field($_GET['filter'] ?? ''));
while ($products->have_posts()) : $products->the_post();
    echo '<h2>' . esc_html(get_the_title()) . '</h2>';
endwhile;
wp_reset_postdata();
```

Same prompt. One is a security nightmare, the other follows WordPress best practices.

## Stack Covered

- **WordPress 6.x** — Hooks, filters, template hierarchy
- **PHP 8.2+** — Strict types, type hints
- **Gutenberg** — Block API v3, `block.json`, React/JSX
- **WooCommerce** — HPOS-compatible, hooks, template overrides
- **ACF PRO** — Field groups, repeaters, ACF blocks
- **REST API** — `register_rest_route`, permissions, validation
- **Security** — Escaping, sanitization, nonces, prepared queries
- **i18n** — `__()`, `_e()`, text domains

## Customizing

These are starting points. Customize for your team:

- Add your plugin namespace to `CLAUDE.md`
- Add project-specific hooks to `.cursorrules`
- Create new skills for your workflows (Elementor widgets, custom page builders, etc.)

## License

MIT — [Mustafa Vatandas](https://github.com/mvtandas)
