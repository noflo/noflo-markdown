noflo = require 'noflo'
marked = require 'marked'

class ParseMarkdown extends noflo.Component
  constructor: ->
    @gfm = false
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Markdown source'
      gfm:
        datatype: 'boolean'
        description: 'Use GitHub-flavored Markdown'
        default: false
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
      error:
        datatype: 'object'
        required: false

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (data) =>
      try
        @outPorts.out.send marked data,
          gfm: @gfm
      catch e
        @outPorts.error.send e
        @outPorts.error.disconnect()
    @inPorts.in.on 'endgroup',  =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

    @inPorts.gfm.on 'data', (data) =>
      @gfm = String(data) is 'true'

exports.getComponent = -> new ParseMarkdown
