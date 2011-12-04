document = @args[0]

authorLinks = @layout 'author-links', document.author
span "by #{authorLinks}"
text ' | '
span property: 'dc:created', "#{document.date.toShortDateString()}"
tagLinks = @layout 'tag-links', document.tags
text " | #{tagLinks} | "
span """<a href="#{document.url}#disqus_thread" data-disqus-identifier="#{document.url}"></a>"""

