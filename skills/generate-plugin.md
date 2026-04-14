# /generate-plugin

Generate a WordPress plugin skeleton with proper structure and boilerplate.

## Usage
```
/generate-plugin my-plugin --name "My Plugin" --description "Does awesome things"
```

## Instructions

Create the following structure:

```
my-plugin/
├── my-plugin.php              # Main plugin file
├── includes/
│   ├── class-my-plugin.php    # Main class
│   ├── class-activator.php    # Activation logic
│   ├── class-deactivator.php  # Deactivation logic
│   ├── class-admin.php        # Admin hooks/pages
│   └── class-public.php       # Public hooks
├── admin/
│   └── views/                 # Admin templates
├── public/
│   └── views/                 # Public templates
├── languages/                 # i18n
├── uninstall.php              # Cleanup
└── composer.json
```

Main plugin file template:
```php
<?php
declare(strict_types=1);

/**
 * Plugin Name:       {name}
 * Description:       {description}
 * Version:           1.0.0
 * Author:            {author}
 * License:           GPL-2.0+
 * Text Domain:       {slug}
 * Domain Path:       /languages
 */

if (!defined('ABSPATH')) {
    exit;
}

define('{PREFIX}_VERSION', '1.0.0');
define('{PREFIX}_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('{PREFIX}_PLUGIN_URL', plugin_dir_url(__FILE__));

require_once {PREFIX}_PLUGIN_DIR . 'includes/class-{slug}.php';

register_activation_hook(__FILE__, ['{ClassName}_Activator', 'activate']);
register_deactivation_hook(__FILE__, ['{ClassName}_Deactivator', 'deactivate']);

(new {ClassName}())->run();
```

Rules:
- `declare(strict_types=1)` on every PHP file
- Prefix all functions, classes, hooks with plugin slug
- Include uninstall.php for cleanup
- Use WordPress Settings API for admin pages
- Text domain must match plugin slug
