anEntry = (url, lastmod, freq) ->
  tag 'url', ->
    tag 'url', href: "#{@site.url}#{url}"
    tag 'lastmod', lastmod
    tag 'changefreq', freq

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'urlset', xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation':'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd', ->
  anEntry '', @site.date.toIsoDateString(), 'weekly'
  for document in @documents
    anEntry document.url, document.date.toIsoDateString(), 'never' if 0 is document.url.indexOf '/articles'
    anEntry document.url, @site.date.toIsoDateString(), 'weekly' if 0 is document.url.indexOf '/site'

