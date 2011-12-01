---
layout: default
---

@document.firstRendered or= @content

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header ->
    h1 property: 'dcterms:title', "#{@document.title}"

  footer ->
    span ->
      text 'by '
      @authors.render @document.author
    text ' | '
    span property: 'dc:created', "#{@document.date.toShortDateString()}"
    text ' | '
    tagsRendered = []
    for tag in @document.tags
      tagsRendered.push """<a href="/site/tagmap.html##{tag.toLowerCase()}">#{tag}</a>"""
    span tagsRendered.join ', '
    text ' | '
    span """<a href="#{@document.url}#disqus_thread" data-disqus-identifier="#{@document.url}"></a>"""


  div property: 'sioc:content', -> "#{@content}"


if @document.relatedDocuments.length > 0
  section '#related', ->
    h3 'Related Posts'
    nav '#linklist', ->
      for document in @document.relatedDocuments
        li ->
          span "#{document.date.toShortDateString()}"
          text '&raquo;'
          a herf: "#{document.url}", "#{document.title}"

section '#comments', ->
  h3 'Feedback'

  text """
<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_shortname = '#{@site.disqusShortName}';
    var disqus_identifier = '#{@document.url}';
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    """

