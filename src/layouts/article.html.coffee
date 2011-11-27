---
layout: default
---

@document.firstRendered or= @content

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  h1 property: 'dcterms:title', "#{@document.title}"
  div property: 'sioc:content', -> "#{@content}"


if @document.relatedDocuments.length > 0
  section '#related', ->
    h3 'Related Posts'
    nav '#linklist', ->
      for document in @document.relatedDocuments
        li ->
          span "#{@document.date.toShortDateString()}"
          text '&raquo;'
          a herf: "#{@document.url}", "#{@document.title}"

section '#comments', ->
  h3 'Feedback'
  div id: 'disqus_thread'
  script ->
    '''
    $(function(){
    // Prepare
      window.disqus_shortname = 'balupton';
      window.disqus_developer = document.location.href.indexOf('localhost') ? 1 : 0;
      window.disqus_identifier = "#{@document.slug}";
      window.disqus_url = "http://balupton.com#{#document.url}";
      // Reset
      if ( typeof window.DISQUS !== 'undefined' ) {
        window.DISQUS.reset({
          reload: true,
          config: function () {
            this.page.identifier = "#{@Document.slug}";
            this.page.url = "http://balupton.com#{@document.url}";
          }
        });
      }
    });
    '''
  noscript 'life would be cooler if you enabled javascript *sigh*'

