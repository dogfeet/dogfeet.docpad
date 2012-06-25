document = @args[0]

dateWrapper = @tool.moment document.get('date')
dateStr = dateWrapper.format('YYYY MMM DD')
authorLinks = @layout 'author-links', document.get('author')
tagLinks = @layout 'tag-links', document.get('tags')

span "by #{authorLinks}"
text ' | '
span property: 'dc:created', "#{dateStr}"
text " | #{tagLinks} | "
span """<a href="#{document.get('url')}#disqus_thread" data-disqus-identifier="#{document.get('url')}"></a>"""
