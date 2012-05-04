anEntry = (url, lastmod, freq) ->
  tag 'url', ->
    tag 'loc', "#{@site.url}#{url}"
    tag 'lastmod', lastmod
    tag 'changefreq', freq

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'urlset', xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation':'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd', ->
  anEntry '', @site.date.toIsoDateString(), 'weekly'
  siteDate = @site.date
  @documents.forEach (document)->
    if document.encoding != 'binary' and 0 is document.url.indexOf '/articles'
      anEntry document.url, document.date.toIsoDateString(), 'never'
    else
      anEntry document.url, siteDate.toIsoDateString(), 'weekly' 
