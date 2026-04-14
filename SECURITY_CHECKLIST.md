# WordPress Security Checklist

Use this checklist before every PR, deployment, or code review. Ask Claude to run `/security-check` on your code.

## Output Escaping ✅

Every `echo` statement must use an escape function:

| Function | Use for |
|----------|---------|
| `esc_html()` | HTML content, text nodes |
| `esc_attr()` | HTML attributes |
| `esc_url()` | URLs (href, src, action) |
| `esc_js()` | Inline JavaScript strings |
| `esc_textarea()` | Textarea content |
| `wp_kses_post()` | Rich HTML (post content) |
| `wp_kses()` | HTML with custom allowed tags |

```php
// ❌ BAD
echo $title;
echo '<a href="' . $url . '">';

// ✅ GOOD
echo esc_html($title);
echo '<a href="' . esc_url($url) . '">';
```

## Input Sanitization ✅

Every `$_GET`, `$_POST`, `$_REQUEST` must be sanitized:

| Function | Use for |
|----------|---------|
| `sanitize_text_field()` | Short text inputs |
| `sanitize_textarea_field()` | Multiline text |
| `sanitize_email()` | Email addresses |
| `sanitize_url()` | URLs |
| `absint()` | Positive integers |
| `intval()` | Integers |
| `wp_unslash()` | Remove WordPress slashes (use before sanitizing) |

```php
// ❌ BAD
$name = $_POST['name'];

// ✅ GOOD
$name = sanitize_text_field(wp_unslash($_POST['name'] ?? ''));
```

## Database Queries ✅

- [ ] All queries use `$wpdb->prepare()`
- [ ] No string concatenation in SQL
- [ ] Use `%s` for strings, `%d` for integers, `%f` for floats

```php
// ❌ BAD
$wpdb->get_results("SELECT * FROM {$wpdb->posts} WHERE ID = $id");

// ✅ GOOD
$wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE ID = %d",
    $id
));
```

## Nonce Verification ✅

- [ ] All forms include `wp_nonce_field()`
- [ ] All form handlers verify with `wp_verify_nonce()`
- [ ] All AJAX handlers verify with `check_ajax_referer()`

```php
// Form
wp_nonce_field('my_action', 'my_nonce');

// Handler
if (!wp_verify_nonce($_POST['my_nonce'] ?? '', 'my_action')) {
    wp_die('Security check failed');
}
```

## Capability Checks ✅

- [ ] All admin actions check `current_user_can()`
- [ ] REST API endpoints have `permission_callback`
- [ ] AJAX handlers verify user capabilities

```php
if (!current_user_can('manage_options')) {
    wp_die('Unauthorized');
}
```

## File Uploads ✅

- [ ] Validate file type with `wp_check_filetype()`
- [ ] Use `wp_handle_upload()`, never `move_uploaded_file()`
- [ ] Check file size
- [ ] Never trust file extension alone

## Quick Audit Command

Ask Claude Code:
```
Review all PHP files in this project for security issues:
- Unescaped output
- Unsanitized input
- Raw SQL queries
- Missing nonce verification
- Missing capability checks
```
