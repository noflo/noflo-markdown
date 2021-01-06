const noflo = require('noflo');
const fromMarkdown = require('commonmark');

exports.getComponent = () => {
  const c = new noflo.Component();
  c.description = 'Convert Markdown to HTML';
  c.inPorts.add('in', {
    datatype: 'string',
    description: 'Markdown source',
  });
  c.outPorts.add('out', {
    datatype: 'string',
  });
  c.outPorts.add('error', {
    datatype: 'object',
    required: false,
  });

  return c.process((input, output) => {
    if (!input.hasData('in')) { return; }
    const data = input.getData('in');

    const reader = new fromMarkdown.Parser();
    const renderer = new fromMarkdown.HtmlRenderer();
    const ast = reader.parse(data);
    output.sendDone({ out: renderer.render(ast) });
  });
};
