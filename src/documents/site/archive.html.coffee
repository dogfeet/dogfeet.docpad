--- yaml
layout: 'default'
---

style rel: 'stylesheet', media: 'screen, projection', scoped: 'scoped', ->
  """
  .article_footer {
    margin-left: 10px;
  }
  """

header ->
  h2 'Archives'
for document in @documents
  if 0 is document.url.indexOf '/article'
    dateWrapper = @tool.moment document.date
    div '.row', ->
      span '.span2', dateWrapper.format('YYYY MMM DD')

      div '.span9', ->
        a href: document.url, property: 'dc:title', ->
          strong "#{document.title}"
        div '.article_footer', -> small ->
          tagLinks = @layout 'tag-links', document.tags
          authorLinks = @layout 'author-links', document.author

          text " posted in #{tagLinks} by #{authorLinks}"

