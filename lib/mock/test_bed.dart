part of angular.mock;

/**
 * Class which simplifies bootstraping of angular for unit tests.
 *
 * Simply inject [TestBed] into the test, then use [compile] to
 * match directives against the view.
 */
class TestBed {
  final Injector injector;
  final Scope rootScope;
  final Compiler compiler;
  final Parser parser;


  Element rootElement;
  List<Node> rootElements;
  Block rootBlock;

  TestBed(
      Injector this.injector,
      Scope this.rootScope,
      Compiler this.compiler,
      Parser this.parser);


  /**
   * Use to compile HTML and activete its directives.
   *
   * If [html] parametr is:
   *
   *   - [String] then treat it as HTML
   *   - [Node] then treat it as the root node
   *   - [List<Node>] then treat it as a collection of nodse
   *
   * After the compilation the [rootElements] contains an array of compiled root nodes,
   * and [rootElement] contains the first element from the [rootElemets].
   *
   */
  Element compile(html) {
    if (html is String) {
      rootElements = toNodeList(html);
    } else if (html is Node) {
      rootElements = [html];
    } else if (html is List<Node>) {
      rootElements = html;
    } else {
      throw 'Expecting: String, Node, or List<Node> got $html.';
    }
    rootElement = rootElements[0];
    rootBlock = compiler(rootElements)(injector, rootElements);
    return rootElement;
  }

  /**
   * Convert an [html] String to a [List] of [Element]s.
   */
  List<Element> toNodeList(html) {
    var div = new DivElement();
    div.setInnerHtml(html, treeSanitizer: new NullTreeSanitizer());
    var nodes = [];
    for(var node in div.nodes) {
      nodes.add(node);
    }
    return nodes;
  }

  /**
   * Triggern a specific DOM element on a given node to test directives
   * which listen to events.
   */
  triggerEvent(element, name, [type='MouseEvent']) {
    element.dispatchEvent(new Event.eventType(type, name));
  }

  /**
   * Select an [OPTION] in a [SELECT] with a given name and trigger the
   * appropriate DOM event. Used when testing [SELECT] controlls in forms.
   */
  selectOption(element, text) {
    element.queryAll('option').forEach((o) => o.selected = o.text == text);
    triggerEvent(element, 'change');
  }
}
