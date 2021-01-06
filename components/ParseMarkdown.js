/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const noflo = require('noflo');
const fromMarkdown = require('commonmark');

exports.getComponent = function() {
  const c = new noflo.Component;
  c.description = 'Convert Markdown to HTML';
  c.inPorts.add('in', {
    datatype: 'string',
    description: 'Markdown source'
  }
  );
  c.inPorts.add('gfm', {
    datatype: 'boolean',
    description: 'Use GitHub-flavored Markdown',
    default: false,
    control: true
  }
  );
  c.outPorts.add('out',
    {datatype: 'string'});
  c.outPorts.add('error', {
    datatype: 'object',
    required: false
  }
  );

  return c.process(function(input, output) {
    if (!input.hasData('in')) { return; }
    if (input.attached('gfm').length && !input.hasData('gfm')) { return; }
    const data = input.getData('in');

    const gfm = input.has('gfm') ? input.getData('gfm') : false;

    const reader = new fromMarkdown.Parser;
    const renderer = new fromMarkdown.HtmlRenderer;
    const ast = reader.parse(data);
    return output.sendDone({
      out: renderer.render(ast)});
  });
};
