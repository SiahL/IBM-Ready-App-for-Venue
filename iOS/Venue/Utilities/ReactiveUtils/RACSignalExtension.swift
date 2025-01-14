//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

// Pulled from https://github.com/ColinEberhardt/SwiftReactivePlayground


import Foundation
import ReactiveCocoa

// a collection of extension methods that allows for strongly typed closures, and remove 
// some ugly implicit optionals
extension RACSignal {
  
  func subscribeNextAs<T>(nextClosure:(T) -> ()) -> () {
    self.subscribeNext {
      (next: AnyObject!) -> () in
      let nextAsT = next! as! T
      nextClosure(nextAsT)
    }
  }

  func subscribeNextAs<T>(nextClosure:(T) -> (), error: (NSError) -> (), completed:() ->()) -> () {
    self.subscribeNext({
      (next: AnyObject!) -> () in
      let nextAsT = next! as! T
      nextClosure(nextAsT)
    }, error: {
      (err: NSError!) -> () in
      error(err)
    }, completed: completed)
  }
  
  func mapAs<T: AnyObject, U: AnyObject>(mapClosure:(T) -> U) -> RACSignal {
    return self.map {
      (next: AnyObject!) -> AnyObject! in
      let nextAsT = next as! T
      return mapClosure(nextAsT)
    }
  }
  
  func filterAs<T: AnyObject>(filterClosure:(T) -> Bool) -> RACSignal {
    return self.filter {
      (next: AnyObject!) -> Bool in
      let nextAsT = next as! T
      return filterClosure(nextAsT)
    }
  }
  
  func doNextAs<T: AnyObject>(nextClosure:(T) -> ()) -> RACSignal {
    return self.doNext {
      (next: AnyObject!) -> () in
      let nextAsT = next as! T
      nextClosure(nextAsT)
    }
  }
}

class RACSignalEx {
  class func combineLatestAs<T, U, R: AnyObject>(signals:[RACSignal], reduce:(T,U) -> R) -> RACSignal {
    return RACSignal.combineLatest(signals).mapAs {
      (tuple: RACTuple) -> R in
      return reduce(tuple.first as! T, tuple.second as! U)
    }
  }
}

func && (op1: NSNumber, op2: NSNumber) -> Bool {
  return op1.boolValue && op2.boolValue
}
