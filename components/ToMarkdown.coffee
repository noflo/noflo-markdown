noflo = require 'noflo'
upndown = require 'upndown'

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
    und = new upndown
    markdown = und.convert data
    out.send markdown.replace '<', "\n<", 'g'
  c
