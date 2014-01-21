node-cgminer
============

Usage
-----

CGMiner command return a Promises/A compatible promise (specifically a [Q](https://github.com/kriskowal/q) promise):

    var client = new CGMinerClient(HOST, PORT);
    client.COMMAND(ARG1, ARG2).then(function(results) {
      console.log(results);
    }, function(err) {
      // error handler
    });

COMMAND corresponds to one of the commands detailed in [CGMiner's API documentation](https://github.com/ckolivas/cgminer/blob/master/API-README).

TODO
----

* Some commands return the raw JSON response object while other return a customized object (`devs`, etc).
* Documentation.
