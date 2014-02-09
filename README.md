KKWeakProxy
===========

`KKWeakProxy` allows you to store a weak reference to an object in arrays, dictionaries, strong properties, etc.

Usage
-----

`+[KKWeakProxy proxyForTarget:]` creates a proxy object with a weak reference to the target. It will forward all messages to its target until it gets deallocated, after which it will continue forwarding messages to a `KKNil` object. Thanks to associated objects, it will not get deallocated before its target and asking for a weak proxy for the same target multiple times will return the same proxy. The implementation should be thread-safe.

Such proxies can be sometimes useful to prevent retain cycles, although in most cases they shouldn't be necessary.
