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

  c.process (input, output) ->
    return unless input.has 'in'
    data = input.get 'in'
    return unless data.type is 'data'

    markdown = md data,
      allowTags: true

    output.sendOne
      out: markdown
