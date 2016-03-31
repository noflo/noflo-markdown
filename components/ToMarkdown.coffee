noflo = require 'noflo'
md = require 'html-md'

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
    return unless input.has 'tags', 'in'
    [tags, data] = input.get 'tags', 'in'
    return unless data.type is 'data'

    markdown = md data.data,
      allowTags: tags.data

    output.sendDone
      out: markdown
