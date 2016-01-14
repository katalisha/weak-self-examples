import Foundation

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


class willDeinit2 {
  var title = "will not deinit"
  var closure : (Void -> Void)!


  func doSomething() {
    weak var weakSelf = self
    func doSomethingElse() {
      print(weakSelf?.title)
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





