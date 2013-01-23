parser = require "../components/ToMarkdown"
socket = require('noflo').internalSocket

setupComponent = ->
  c = parser.getComponent()
  ins = socket.createSocket()
  out = socket.createSocket()
  c.inPorts.in.attach ins
  c.outPorts.out.attach out
  [c, ins, out]

exports['test converting simple HTML'] = (test) ->
  test.expect 1
  [c, ins, out] = setupComponent()
  out.once 'data', (data) ->
    test.equal data, "I am using **markdown**."
    test.done()
  ins.send "<p>I am using <strong>markdown</strong>.</p>\n"

exports['test converting HTML with DIVs'] = (test) ->
  test.expect 1
  [c, ins, out] = setupComponent()
  out.once 'data', (data) ->
    test.equal data, "I am using **markdown**."
    test.done()
  ins.send "<div class='foo'><p>I am <span>using</span> <strong>markdown</strong>.</p></div>\n"
