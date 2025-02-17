((a,b,c)=>{a[b]=a[b]||{}
a[b][c]=a[b][c]||[]
a[b][c].push({p:"main.dart.js_8",e:"beginPart"})})(self,"$__dart_deferred_initializers__","eventLog")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,D,A={
Dv(){D.b.m($.bf,new A.ue())},
eO:function eO(d){this.a=d},
ue:function ue(){}},C
B=c[0]
D=c[2]
A=a.updateHolder(c[5],A)
C=c[18]
A.eO.prototype={
F(d){return this.F(0)},
gJ(d){return"Mastering Async Programming in Dart"},
ga4(){return"dart-async-programming"},
gU(){return B.bP("2024-01-30")},
ga0(){return B.a(["dart","async","programming","tutorials"],x.d)},
gah(d){return y.d},
gY(){return"Sarah Chen"},
gZ(){return"https://images.unsplash.com/photo-1629654297299-c8506221ca97"},
ga1(){return null},
gal(d){return"<h1>Mastering Async Programming in Dart</h1>\n<p>\nAsynchronous programming is a crucial skill for modern developers. In this comprehensive guide, we\\'ll explore how Dart handles async operations and how you can write better concurrent code.</p>\n<h2>Understanding Futures</h2>\n<p>\nA <code>Future</code> represents a value that will be available at some point in the future. Here\\'s a simple example:</p>\n<pre><code class=\"language-dart\">Future&lt;String&gt; fetchUserData() async {\n  // Simulate network delay\n  await Future.delayed(Duration(seconds: 2));\n  return \\'User Data\\';\n}\n\nvoid main() async {\n  print(\\'Fetching data...\\');\n  final data = await fetchUserData();\n  print(\\'Data received: $data\\');\n}\n</code></pre>\n<h2>Working with Streams</h2>\n<p>\nStreams are perfect for handling sequences of asynchronous events. Here\\'s how you can use them:</p>\n<pre><code class=\"language-dart\">Stream&lt;int&gt; countDown(int from) async* {\n  for (int i = from; i &gt;= 0; i--) {\n    await Future.delayed(Duration(seconds: 1));\n    yield i;\n  }\n}\n\nvoid main() async {\n  await for (final number in countDown(5)) {\n    print(number);\n  }\n  print(\\'Blast off! \ud83d\ude80\\');\n}\n</code></pre>\n<h2>Error Handling</h2>\n<p>\nAlways handle errors in async code properly:</p>\n<pre><code class=\"language-dart\">Future&lt;void&gt; riskyOperation() async {\n  try {\n    await Future.error(\\'Something went wrong\\');\n  } catch (e) {\n    print(\\'Error caught: $e\\');\n  }\n}\n</code></pre>\n<h2>Best Practices</h2>\n<p>1. Always use <code>async/await</code> over <code>.then()</code> for better readability\n2. Handle errors appropriately using try-catch\n3. Cancel streams when they\\'re no longer needed\n4. Use <code>Future.wait</code> for parallel operations\n5. Consider using <code>StreamController</code> for custom streams</p>\n<h2>Conclusion</h2>\n<p>\nMastering async programming in Dart opens up possibilities for building responsive and efficient applications. Practice these concepts, and you\\'ll be writing better async code in no time!</p>"},
gak(){return"/blog/dart-async-programming"},
gaf(){return y.d},
gT(d){return null},
$ia2:1}
var z=a.updateTypes(["eO()"])
A.ue.prototype={
$0(){return C.aa},
$S:z+0};(function inheritance(){var w=a.inherit
w(A.eO,B.x)
w(A.ue,B.ba)})()
B.bW(b.typeUniverse,JSON.parse('{"eO":{"a2":[],"x":[]}}'))
var y={d:"Learn how to write efficient asynchronous code in Dart using Future, async/await, and Streams. Master error handling and best practices for concurrent programming."}
var x={d:B.a7("G<c>")};(function constants(){C.aa=new A.eO(null)})()};
((a,b)=>{a[b]=a.current
a.eventLog.push({p:"main.dart.js_8",e:"endPart",h:b})})($__dart_deferred_initializers__,"xeI3vlDZ41J7lHDXKBQgOWejGK8=");
//# sourceMappingURL=main.dart.js_8.part.js.map
