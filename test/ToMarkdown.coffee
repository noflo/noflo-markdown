test = require 'noflo-test'

test.component('markdown/ToMarkdown').
  discuss('When receiving simple HTML').
    send.data('in', "<p>I am using <strong>markdown</strong>.</p>\n").
    discuss('Generated Markdown should be sent out').
      receive.data('out', 'I am using **markdown**.').
  next().
  discuss('When receiving HTML with DIVs').
    send.data('in', "<div class='foo'><p>I am <span>using</span> <strong>markdown</strong>.</p></div>\n").
    discuss('Generated Markdown should be sent out with DIVs stripped').
      receive.data('out', 'I am using **markdown**.').
  next().
  discuss('When receiving HTML with IFRAMEs').
    send.data('in', "<h1>Hello world</h1><iframe src=\"//player.vimeo.com/video/99873002?color=ffffff\" width=\"500\" height=\"281\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>").
    discuss('Generated Markdown should be sent out with IFRAME kept').
      receive.data('out', "# Hello world\n\n<iframe src=\"//player.vimeo.com/video/99873002?color=ffffff\" width=\"500\" height=\"281\" frameborder=\"0\" webkitallowfullscreen=\"\" mozallowfullscreen=\"\" allowfullscreen=\"\" style=\"\"></iframe>").
export module
