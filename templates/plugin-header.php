<?php
declare(strict_types=1);

/**
 * Plugin Name:       {{PLUGIN_NAME}}
 * Plugin URI:        {{PLUGIN_URI}}
 * Description:       {{DESCRIPTION}}
 * Version:           1.0.0
 * Requires at least: 6.0
 * Requires PHP:      8.2
 * Author:            {{AUTHOR}}
 * Author URI:        {{AUTHOR_URI}}
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       {{TEXT_DOMAIN}}
 * Domain Path:       /languages
 *
 * @package {{NAMESPACE}}
 */

if (!defined('ABSPATH')) {
    exit;
}

define('{{PREFIX}}_VERSION', '1.0.0');
define('{{PREFIX}}_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('{{PREFIX}}_PLUGIN_URL', plugin_dir_url(__FILE__));
define('{{PREFIX}}_PLUGIN_BASENAME', plugin_basename(__FILE__));

// Autoloader
if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    require_once __DIR__ . '/vendor/autoload.php';
}

// Core includes
require_once {{PREFIX}}_PLUGIN_DIR . 'includes/class-{{SLUG}}.php';
require_once {{PREFIX}}_PLUGIN_DIR . 'includes/class-{{SLUG}}-activator.php';
require_once {{PREFIX}}_PLUGIN_DIR . 'includes/class-{{SLUG}}-deactivator.php';

// Activation & deactivation
register_activation_hook(__FILE__, ['{{CLASS_NAME}}_Activator', 'activate']);
register_deactivation_hook(__FILE__, ['{{CLASS_NAME}}_Deactivator', 'deactivate']);

// Initialize
add_action('plugins_loaded', function (): void {
    (new {{CLASS_NAME}}())->run();
});
