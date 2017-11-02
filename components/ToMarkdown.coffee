noflo = require 'noflo'
toMarkdown = require 'html2commonmark'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert HTML to Markdown'

  c.inPorts.add 'in',
    datatype: 'string'
    description: 'HTML source'
  c.inPorts.add 'tags',
    datatype: 'boolean'
    description: 'Whether to allow HTML tags inside Markdown'
    default: true
    control: true
  c.outPorts.add 'out',
    datatype: 'string'

  c.process (input, output) ->
    return unless input.hasData 'in'
    return if input.attached('tags').length and not input.hasData 'tags'
    data = input.getData 'in'

    tags = if input.has('tags') then input.getData('tags') else true

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

    output.sendDone
      out: markdown
