document = @args[0]

authorLinks = @helper.genAuthors document.get('author')
tagLinks = @helper.genTags document.get('tags')

span "&nbsp; by #{authorLinks}"
text " | #{tagLinks} | "
span """<a href="#{document.get('url')}#disqus_thread" data-disqus-identifier="#{document.get('url')}"></a>"""
