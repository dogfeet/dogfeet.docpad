document = @args[0]

dateWrapper = @tool.moment document.date
dateStr = dateWrapper.format('YYYY MMM DD')
authorLinks = @layout 'author-links', document.author
tagLinks = @layout 'tag-links', document.tags

span "by #{authorLinks}"
text ' | '
span property: 'dc:created', "#{dateStr}"
text " | #{tagLinks} | "
span """<a href="#{document.url}#disqus_thread" data-disqus-identifier="#{document.url}"></a>"""