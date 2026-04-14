# Copilot Instructions — WordPress Project

## Framework
- WordPress 6.x with PHP 8.2+ (strict types)
- Follow WordPress Coding Standards (WPCS)
- Gutenberg for blocks, ACF for custom fields
- WooCommerce for e-commerce features

## Generate code that:
- Uses `declare(strict_types=1)` at top of PHP files
- Escapes all output: `esc_html()`, `esc_attr()`, `esc_url()`
- Sanitizes all input: `sanitize_text_field()`, `absint()`
- Uses `$wpdb->prepare()` for ALL database queries
- Verifies nonces: `wp_verify_nonce()`
- Checks capabilities: `current_user_can()`
- Uses `WP_Query` for queries, never `query_posts()`
- Prefixes all functions/hooks with project namespace
- Uses WordPress APIs: `get_option()`, `get_post_meta()`, `get_transient()`
- Registers REST routes with `register_rest_route()` and permission callbacks

## Never generate:
- Raw SQL without `$wpdb->prepare()`
- Unescaped output
- `query_posts()` calls
- `extract()` or `eval()`
- Hardcoded URLs (use `home_url()`, `admin_url()`)
- Short PHP tags `<?`
- Code without nonce verification on forms
