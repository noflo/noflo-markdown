noflo = require 'noflo'
marked = require 'marked'

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
      out.send marked data,
        gfm: c.gfm
    catch e
      c.error e

  c
