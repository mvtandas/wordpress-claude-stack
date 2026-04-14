# WordPress Project — Claude Code Instructions

## Stack
- WordPress 6.x
- PHP 8.2+ (strict types)
- MySQL 8.0 / MariaDB 10.6+
- Gutenberg (Block Editor)
- WooCommerce (if e-commerce)
- Advanced Custom Fields PRO (if applicable)
- Tailwind CSS or classic enqueued styles
- Vite for asset bundling (modern themes)
- Composer for PHP dependencies
- npm/pnpm for frontend dependencies

## Code Style

### PHP
- Always declare `declare(strict_types=1);` at top of files
- Follow WordPress Coding Standards (WPCS)
- Use type hints for all function parameters and return types
- Prefix all functions, classes, and hooks with project namespace
- Use `snake_case` for functions, `UPPER_SNAKE_CASE` for constants
- Escape all output: `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`
- Sanitize all input: `sanitize_text_field()`, `absint()`, `wp_unslash()`
- Use `$wpdb->prepare()` for ALL database queries — never raw SQL

### Theme Development
```
theme/
├── functions.php          # Theme setup, hooks, enqueues
├── inc/
│   ├── setup.php          # add_theme_support, menus, sidebars
│   ├── enqueue.php        # wp_enqueue_script/style
│   ├── custom-post-types.php
│   ├── taxonomies.php
│   ├── customizer.php
│   ├── acf-fields.php     # ACF field group registrations
│   └── template-tags.php  # Reusable template functions
├── template-parts/
│   ├── header/
│   ├── footer/
│   ├── content/
│   └── components/
├── templates/             # Full page templates
├── assets/
│   ├── src/               # Source JS/CSS (Vite input)
│   └── dist/              # Built assets
├── blocks/                # Custom Gutenberg blocks
└── woocommerce/           # WooCommerce template overrides
```

### Plugin Development
```
plugin/
├── plugin-name.php        # Main plugin file with header
├── includes/
│   ├── class-plugin-name.php       # Main plugin class
│   ├── class-activator.php         # Activation hook
│   ├── class-deactivator.php       # Deactivation hook
│   ├── class-admin.php             # Admin functionality
│   ├── class-public.php            # Public functionality
│   └── class-rest-api.php          # REST API endpoints
├── admin/
│   ├── views/             # Admin page templates
│   ├── css/
│   └── js/
├── public/
│   ├── views/
│   ├── css/
│   └── js/
├── languages/             # i18n .pot/.po/.mo files
├── tests/
│   └── phpunit/
├── uninstall.php          # Cleanup on uninstall
└── composer.json
```

### Gutenberg Blocks
- Register blocks with `register_block_type()` in PHP
- Use `@wordpress/scripts` for block build tooling
- Use `block.json` for block metadata
- Use `useBlockProps()` in edit function
- Use `InnerBlocks` for nested content
- Keep edit and save functions in separate files

### WooCommerce
- Override templates in `theme/woocommerce/` directory
- Use WooCommerce hooks, never modify core files
- Key hooks: `woocommerce_before_main_content`, `woocommerce_after_shop_loop_item`
- Use `wc_get_product()`, never direct DB queries for products
- Use `WC()->cart`, `WC()->session` for cart/session data

### Advanced Custom Fields
- Register field groups via PHP (`acf_add_local_field_group`) for version control
- Use `get_field()`, `the_field()`, `have_rows()` / `the_row()` for repeaters
- Use ACF blocks for Gutenberg integration
- Always provide fallback values: `get_field('name') ?: 'Default'`

### REST API
- Register routes with `register_rest_route()`
- Always use permission callbacks
- Validate with `validate_callback`, sanitize with `sanitize_callback`
- Return `WP_REST_Response` or `WP_Error`
```php
register_rest_route('myplugin/v1', '/items', [
    'methods'             => 'GET',
    'callback'            => [$this, 'get_items'],
    'permission_callback' => function() {
        return current_user_can('read');
    },
]);
```

### Database
- Use `$wpdb->prepare()` for ALL queries
- Use WordPress options API for simple data: `get_option()`, `update_option()`
- Use post meta for post-related data: `get_post_meta()`, `update_post_meta()`
- Use transients for cached data: `get_transient()`, `set_transient()`
- Custom tables only when WordPress data structures don't fit

### Security
- Nonce verification on ALL form submissions: `wp_verify_nonce()`
- Capability checks: `current_user_can()`
- Escape ALL output — no exceptions
- Sanitize ALL input — no exceptions
- Use `$wpdb->prepare()` — no raw SQL
- Validate file uploads with `wp_check_filetype()`
- Never use `extract()` or `eval()`

### Hooks & Filters
- Use descriptive hook names: `{namespace}_{context}_{action}`
- Document hooks with `@since`, `@param`, `@return`
- Remove hooks responsibly: `remove_action()` / `remove_filter()` with exact priority
- Use priority 10 (default) unless specific ordering is needed

## Naming Conventions
| What | Convention | Example |
|------|-----------|---------|
| Functions | snake_case with prefix | `mytheme_get_hero_image()` |
| Classes | PascalCase with prefix | `MyPlugin_Admin` |
| Constants | UPPER_SNAKE with prefix | `MYPLUGIN_VERSION` |
| Hooks | snake_case with prefix | `mytheme_after_header` |
| Template files | kebab-case | `content-single.php` |
| Block names | namespace/kebab | `myplugin/hero-banner` |
| REST routes | kebab-case | `/myplugin/v1/items` |
| CSS classes | BEM or kebab-case | `hero__title`, `site-header` |
| JS files | kebab-case | `custom-scripts.js` |
| Options | snake_case with prefix | `mytheme_primary_color` |

## Testing
- PHPUnit with `WP_UnitTestCase` base class
- Use WordPress test factories: `$this->factory->post->create()`
- Test hooks, filters, REST endpoints, and custom queries
- Use `wp_remote_get()` mocks for external API tests

## Do NOT
- Modify WordPress core files
- Use `query_posts()` — use `WP_Query` or `get_posts()`
- Echo unescaped user data
- Write raw SQL without `$wpdb->prepare()`
- Use `extract()` or `eval()`
- Hardcode URLs — use `home_url()`, `admin_url()`, `plugin_dir_url()`
- Skip nonce verification on forms
- Use `wp_remote_get()` without timeout and error handling
- Put business logic in template files — use functions.php or classes
- Use short PHP tags `<?` — always use `<?php`
