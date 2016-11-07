
open class Signal : Emitter {

  open func on (_ handler: @escaping (Void) -> Void) -> Listener {
    return EmitterListener(self, nil, { _ in handler() }, false)
  }
  
  open func on (_ target: AnyObject, _ handler: @escaping (Void) -> Void) -> Listener {
    return EmitterListener(self, target, { _ in handler() }, false)
  }
  
  open func once (_ handler: @escaping (Void) -> Void) -> Listener {
    return EmitterListener(self, nil, { _ in handler() }, true)
  }
  
  open func once (_ target: AnyObject, _ handler: @escaping (Void) -> Void) -> Listener {
    return EmitterListener(self, target, { _ in handler() }, true)
  }
  
  open func emit () {
    super.emit(nil, nil)
  }
  
  open func emit (_ target: AnyObject) {
    super.emit(target, nil)
  }
  
  open func emit (_ targets: [AnyObject]) {
    super.emit(targets, nil)
  }
  
  public override init () {
    super.init()
  }
}
