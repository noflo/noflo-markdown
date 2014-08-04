noflo = require 'noflo'
md = require 'html-md'

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
    out.send md data,
      allowTags: true

  c
