/**
 * See https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html
 */

import Foundation


/**
 * The closure captures self and is assigned to self creating a retain loop
 */
class willNotDeinit {
  var title = "will not deinit"
  var closure : (Void -> Void)!

  func doSomething() {
    closure = {
      print(self.title)
    }
    closure()
  }

  deinit {
    print("DEALLOCATED")
  }
}

/**
 * The nested function is a closure in disguise, it captures self and is them assigned to self via the anonymous closure, creating a retain loop.
 */
class willNotDeinit2 {
  var title = "will not deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    func doSomethingElse() {
      print(self.title)
    }
    closure = {
      doSomethingElse()
    }
    closure()
  }

  deinit {
    print("DEALLOCATED")
  }
}


/**
 * A fix to the example above, self is captured as a weak reference and no retain cycle is made.
 */
class willDeinit2 {
  var title = "will not deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    weak var weakSelf = self
    func doSomethingElse() {
      print(weakSelf!.title)
    }
    closure = {
      doSomethingElse()
    }
    closure()
  }

  deinit {
    print("DEALLOCATED")
  }
}


/**
 * An assigned closure with weak self does not create a retain loop.
 */
class willDeinit {
  var title = "will deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    closure = {[weak self] in
      print(self?.title)
    }
    closure()
  }

  deinit {
    print("DEALLOCATED")
  }
}

/**
 * Nested function captures self but isn't assigned to self so no retain loop.
 */
class nestedFunction {
  var title = "nested function"

  let mappable = [1]

  func doSomething() {
    func closure(number:Int) {
      print(self.title)
    }

    mappable.map(closure)
  }

  deinit {
    print("DEALLOCATED")
  }
}

/**
 * Closure captures self but isn't assigned to self so no retain loop.
 */
class inlineClosure {
  var title = "inline closure"

  let mappable = [1]

  func doSomething() {
    mappable.map{_ in
      print(self.title)
    }
  }

  deinit {
    print("DEALLOCATED")
  }
}

var example1 : willNotDeinit? = willNotDeinit()
example1!.doSomething()
example1 = nil

var example2 : willDeinit? = willDeinit()
example2!.doSomething()
example2 = nil

var example3 : nestedFunction? = nestedFunction()
example3!.doSomething()
example3 = nil

var example4: inlineClosure? = inlineClosure()
example4?.doSomething()
example4 = nil

var example5: willNotDeinit2? = willNotDeinit2()
example5?.doSomething()
example5 = nil


var example6: willDeinit2? = willDeinit2()
example6?.doSomething()
example6 = nil


