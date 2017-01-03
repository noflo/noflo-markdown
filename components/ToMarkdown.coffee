noflo = require 'noflo'
toMarkdown = require 'html2commonmark'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert HTML to Markdown'

  c.inPorts.add 'in',
    datatype: 'string'
    description: 'HTML source'
  c.outPorts.add 'out',
    datatype: 'string'

  noflo.helpers.WirePattern c,
    in: ['in']
    out: 'out'
    forwardGroups: true
  , (data, groups, out) ->
    converterOptions =
      rawHtmlElements: ['iframe', 'article', 'video', 'table']
      interpretUnknownHtml: false

    if noflo.isBrowser()
      converter = new toMarkdown.BrowserConverter converterOptions
    else
      converter = new toMarkdown.JSDomConverter converterOptions
    renderer = new toMarkdown.Renderer()
    ast = converter.convert data
    markdown = renderer.render ast
    out.send markdown
