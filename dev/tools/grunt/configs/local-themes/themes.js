/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */

'use strict';

/**
 * Define Themes
 *
 * area: area, one of (frontend|adminhtml|doc),
 * name: theme name in format Vendor/theme-name,
 * locale: locale,
 * files: [
 * 'css/styles-m',
 * 'css/styles-l'
 * ],
 * dsl: dynamic stylesheet language (less|sass)
 *
 */
module.exports = {
    absolute: {
        area: 'frontend',
        name: 'Swissup/absolute',
        locale: 'vi_VN',
        files: [
            'css/styles-m',
            'css/styles-l',
            'css/print',
            'css/email',
            'css/email-inline'
        ],
        dsl: 'less'
    },
    kasitoo: {
        area: 'frontend',
        name: 'Venustheme/kasitoo',
        locale: 'vi_VN',
        files: [
            'css/styles-m',
            'css/styles-l',
            'css/print',
            'css/email',
            'css/email-inline'
        ],
        dsl: 'less'
    },
};
