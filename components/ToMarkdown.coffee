noflo = require 'noflo'
md = require 'html-md'

class ToMarkdown extends noflo.Component
  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'HTML source'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (data) =>
      @outPorts.out.send md data
    @inPorts.in.on 'endgroup',  =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new ToMarkdown
