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
    return unless input.has 'in'
    data = input.get 'in'
    return unless data.type is 'data'

    tags = if input.has('tags') then input.getData('tags') else true

    markdown = md data.data,
      allowTags: tags

    output.sendDone
      out: markdown
