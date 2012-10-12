document = @args[0]

dateStr = @helper.formatDate( document.get('date') )
authorLinks = @helper.genAuthors document.get('author')
tagLinks = @helper.genTags document.get('tags')

span "by #{authorLinks}"
text ' | '
span property: 'dc:created', "#{dateStr}"
text " | #{tagLinks} | "
span """<a href="#{document.get('url')}#disqus_thread" data-disqus-identifier="#{document.get('url')}"></a>"""
