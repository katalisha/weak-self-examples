/**
 * See https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html
 */

import Foundation

protocol DoesSomething {
  func doSomething()
}

/**
 * Capturing properties of self in a closure without referencing self will not compile
 */
class CompilerWarning : DoesSomething {
  var message = "CompilerWarning Will not compile"

  func doSomething() {
    let _ = {
      // print(message) // Error message: Instance member 'message' cannot be used on type 'CompilerWarning'
    }
  }

  deinit {
    print("CompilerWarning DEALLOCATED")
  }
}


/**
 * The closure captures self and is assigned to self creating a retain loop
 */
class MemoryLeak1 : DoesSomething {
  var message = "MemoryLeak1 will not deinit"
  var closure : (Void -> Void)!

  func doSomething() {
    closure = {
      print(self.message)
    }
    closure()
  }

  deinit {
    print("MemoryLeak1 DEALLOCATED") // Not called
  }
}

/**
 * The nested function is a closure in disguise, it captures self and is them assigned to self via the anonymous closure, creating a retain loop.
 */
class MemoryLeak2 : DoesSomething {
  var message = "MemoryLeak2 will not deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    func doSomethingElse() {
      print(self.message)
    }
    closure = {
      doSomethingElse()
    }
    closure()
  }

  deinit {
    print("MemoryLeak2 DEALLOCATED") // Not called
  }
}


/**
 * A fix to the example above, self is captured as a weak reference and no retain cycle is made.
 */
class SafeNestedFunctionWeakVar : DoesSomething {
  var message = "SafeNestedFunctionWeakVar will not deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    weak var weakSelf = self
    func doSomethingElse() {
      print(weakSelf!.message)
    }
    closure = {
      doSomethingElse()
    }
    closure()
  }

  deinit {
    print("SafeNestedFunctionWeakVar DEALLOCATED")
  }
}


/**
 * An assigned closure with weak self does not create a retain loop.
 */
class WeakSelfClosure : DoesSomething {
  var message = "WeakSelfClosure will deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    closure = {[weak self] in
      print(self?.message)
    }
    closure()
  }

  deinit {
    print("WeakSelfClosure DEALLOCATED")
  }
}

/**
 * Nested function captures self but isn't assigned to self so no retain loop.
 */
class NoAssignementNestedFunction : DoesSomething {
  var message = "NoAssignementNestedFunction nested function"

  let mappable = [1]

  func doSomething() {
    func closure(number:Int) {
      print(self.message)
    }

    mappable.map(closure)
  }

  deinit {
    print("NoAssignementNestedFunction DEALLOCATED")
  }
}

/**
 * Closure captures self but isn't assigned to self so no retain loop.
 */
class SafeInlineClosure : DoesSomething {
  var message = "SafeInlineClosure inline closure"

  let mappable = [1]

  func doSomething() {
    mappable.map{_ in
      print(self.message)
    }
  }

  deinit {
    print("SafeInlineClosure DEALLOCATED")
  }
}

var example : DoesSomething?

example = CompilerWarning()
example!.doSomething()
example = nil

example = MemoryLeak1()
example!.doSomething()
example = nil

example = MemoryLeak2()
example!.doSomething()
example = nil

example = SafeNestedFunctionWeakVar()
example!.doSomething()
example = nil

example = WeakSelfClosure()
example!.doSomething()
example = nil

example = NoAssignementNestedFunction()
example!.doSomething()
example = nil

example = SafeInlineClosure()
example!.doSomething()
example = nil
