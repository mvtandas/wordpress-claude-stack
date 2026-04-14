# /security-check

Audit WordPress code for common security vulnerabilities.

## Usage
```
/security-check
/security-check includes/class-admin.php
```

## Instructions

Scan all PHP files (or specified file) and check for:

### 1. Unescaped Output
Find any `echo`, `printf`, `print` that doesn't use:
- `esc_html()`, `esc_attr()`, `esc_url()`, `esc_js()`
- `esc_textarea()`, `wp_kses_post()`, `wp_kses()`

### 2. Unsanitized Input
Find any use of `$_GET`, `$_POST`, `$_REQUEST`, `$_SERVER`, `$_COOKIE` without:
- `sanitize_text_field()`, `sanitize_email()`, `sanitize_url()`
- `absint()`, `intval()`, `wp_unslash()`

### 3. SQL Injection
Find any `$wpdb->query()`, `$wpdb->get_results()`, `$wpdb->get_var()` without `$wpdb->prepare()`

### 4. Missing Nonce
Find any form handler (`$_POST` processing) without `wp_verify_nonce()`

### 5. Missing Capability Check
Find any admin action without `current_user_can()`

### 6. Dangerous Functions
Flag any use of:
- `extract()` — variable injection
- `eval()` — code execution
- `unserialize()` without allowed_classes
- `file_get_contents()` on user URLs without validation
- `wp_remote_get()` without timeout

## Output Format

For each issue found:
```
🔴 CRITICAL: [file:line] Unescaped output
   echo $user_input;
   Fix: echo esc_html($user_input);

🟡 WARNING: [file:line] Missing nonce verification
   if (isset($_POST['action'])) { ...
   Fix: Add wp_verify_nonce() check

✅ PASS: No issues found in [file]
```

Report summary at end:
```
Security Audit Summary:
🔴 Critical: X issues
🟡 Warning: X issues
✅ Clean files: X
```
