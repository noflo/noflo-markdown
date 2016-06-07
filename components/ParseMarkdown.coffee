noflo = require 'noflo'
marked = require 'marked'

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
    return unless input.has 'in'
    data = input.get 'in'
    return unless data.type is 'data'

    gfm = if input.has('gfm') then input.getData('gfm') else false

    try
      html = marked data.data,
        gfm: gfm
    catch e
      output.sendDone e
      return

    output.sendDone
      out: html
