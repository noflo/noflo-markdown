parser = require "../components/ParseMarkdown"
socket = require('noflo').internalSocket

setupComponent = ->
  c = parser.getComponent()
  ins = socket.createSocket()
  out = socket.createSocket()
  c.inPorts.in.attach ins
  c.outPorts.out.attach out
  [c, ins, out]

exports['test converting simple Markdown'] = (test) ->
  test.expect 1
  [c, ins, out] = setupComponent()
  out.once 'data', (data) ->
    test.equal data, "<p>I am using <strong>markdown</strong>.</p>\n"
    test.done()
  ins.send "I am using __markdown__."
