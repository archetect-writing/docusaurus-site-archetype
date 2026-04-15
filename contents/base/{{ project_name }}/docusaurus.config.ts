import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: `{{ site_title }}`,
  tagline: `{{ site_tagline }}`,
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

{% if deploy_target == "GitHub Pages" then %}
{% if is_root_domain then %}
  url: 'https://{{ project_name }}',
  baseUrl: '/',
{% else %}
  url: 'https://{{ organization }}.github.io',
  baseUrl: '/{{ project_name }}/',
{% end %}
{% elseif deploy_target == "Vercel" then %}
  url: 'https://{{ project_name }}.vercel.app',
  baseUrl: '/',
{% elseif deploy_target == "Netlify" then %}
  url: 'https://{{ project_name }}.netlify.app',
  baseUrl: '/',
{% else %}
  url: 'https://your-site.example.com',
  baseUrl: '/',
{% end %}

  organizationName: '{{ organization }}',
  projectName: '{{ project_name }}',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

{% if extras_mermaid then %}
  markdown: {
    mermaid: true,
  },
{% end %}

{% if extras_mermaid or extras_search then %}
  themes: [
{% if extras_mermaid then %}
    '@docusaurus/theme-mermaid',
{% end %}
{% if extras_search then %}
    [
      '@easyops-cn/docusaurus-search-local',
      {
        hashed: true,
        indexDocs: true,
        indexBlog: {% if extras_blog then %}true{% else %}false{% end %},
        docsRouteBasePath: '/docs',
      },
    ],
{% end %}
  ],
{% end %}

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
{% if scm_uses_github then %}
          editUrl: 'https://github.com/{{ github_slug }}/tree/main/',
{% end %}
        },
{% if extras_blog then %}
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
{% if scm_uses_github then %}
          editUrl: 'https://github.com/{{ github_slug }}/tree/main/',
{% end %}
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
{% else %}
        blog: false,
{% end %}
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
{% if extras_dark_default then %}
      defaultMode: 'dark',
      respectPrefersColorScheme: false,
{% else %}
      respectPrefersColorScheme: true,
{% end %}
    },
    navbar: {
      title: `{{ site_title }}`,
      logo: {
        alt: `{{ site_title }} Logo`,
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Docs',
        },
{% if extras_blog then %}
        {to: '/blog', label: 'Blog', position: 'left'},
{% end %}
{% if extras_versioned_docs then %}
        {type: 'docsVersionDropdown', position: 'right'},
{% end %}
{% if scm_uses_github then %}
        {
          href: 'https://github.com/{{ github_slug }}',
          label: 'GitHub',
          position: 'right',
        },
{% end %}
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {label: 'Introduction', to: '/docs/intro'},
          ],
        },
{% if scm_uses_github then %}
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/{{ github_slug }}',
            },
          ],
        },
{% end %}
      ],
      copyright: `Copyright © ${new Date().getFullYear()} {{ site_title }}. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
