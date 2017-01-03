noflo = require 'noflo'
fromMarkdown = require 'commonmark'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert Markdown to HTML'
  c.gfm = false
  c.inPorts.add 'in',
    datatype: 'string'
    description: 'Markdown source'
  c.inPorts.add 'gfm',
    datatype: 'boolean'
    description: 'Use GitHub-flavored Markdown'
    default: false
    process: (event, payload) ->
      return unless event is 'data'
  c.outPorts.add 'out',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
    required: false

  noflo.helpers.WirePattern c,
    in: ['in']
    out: 'out'
    forwardGroups: true
  , (data, groups, out) ->
    try
      reader = new fromMarkdown.Parser
      renderer = new fromMarkdown.HtmlRenderer
      ast = reader.parse data
      out.send renderer.render ast
    catch e
      console.log e
