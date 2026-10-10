import { Component } from "@noflo/noflo";
import TurndownService from "turndown";

// HTML elements kept as raw markup in the output, matching the 1.x
// converter's rawHtmlElements setting
const keptElements = ["iframe", "article", "video", "table"];

/**
 * Converts an HTML string to Markdown.
 *
 * Since 2.x this uses turndown, which is isomorphic and maintained; the
 * 1.x implementation used html2commonmark with separate browser and
 * jsdom converters. Conversion output differs from 1.x in formatting
 * details (turndown's traversal).
 * @returns {import("@noflo/noflo").Component} The configured component
 */
export function getComponent() {
  const c = new Component({
    description: "Convert HTML to Markdown",
    icon: "file-text-o",
    inPorts: {
      in: {
        datatype: "string",
        description: "HTML source",
        required: true,
      },
    },
    outPorts: {
      out: {
        datatype: "string",
        description: "Markdown output",
      },
      error: {
        datatype: "object",
      },
    },
  });

  c.process((input, output) => {
    if (!input.hasData("in")) {
      return;
    }
    const data = input.getData("in");
    try {
      const converter = new TurndownService({ headingStyle: "setext" });
      converter.keep(keptElements);
      output.sendDone({ out: converter.turndown(data) });
    } catch (error) {
      output.error(error instanceof Error ? error : new Error(String(error)));
      output.done();
    }
  });

  return c;
}
