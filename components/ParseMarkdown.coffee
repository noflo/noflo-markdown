noflo = require 'noflo'
fromMarkdown = require 'commonmark'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert Markdown to HTML'
  c.inPorts.add 'in',
    datatype: 'string'
    description: 'Markdown source'
  c.inPorts.add 'gfm',
    datatype: 'boolean'
    description: 'Use GitHub-flavored Markdown'
    default: false
    control: true
  c.outPorts.add 'out',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
    required: false

  c.process (input, output) ->
    return unless input.hasData 'in'
    data = input.getData 'in'

    gfm = if input.has('gfm') then input.getData('gfm') else false

    reader = new fromMarkdown.Parser
    renderer = new fromMarkdown.HtmlRenderer
    ast = reader.parse data
    output.sendDone
      out: renderer.render ast
