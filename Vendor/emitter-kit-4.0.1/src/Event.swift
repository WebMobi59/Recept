
open class Event <EventData: Any> : Emitter {

  open func on (_ handler: @escaping (EventData) -> Void) -> Listener {
    return EmitterListener(self, nil, castData(handler), false)
  }
  
  open func on (_ target: AnyObject, _ handler: @escaping (EventData) -> Void) -> Listener {
    return EmitterListener(self, target, castData(handler), false)
  }
  
  open func once (_ handler: @escaping (EventData) -> Void) -> Listener {
    return EmitterListener(self, nil, castData(handler), true)
  }
  
  open func once (_ target: AnyObject, _ handler: @escaping (EventData) -> Void) -> Listener {
    return EmitterListener(self, target, castData(handler), true)
  }
  
  open func emit (_ data: EventData) {
    super.emit(nil, data)
  }

  open func emit (_ target: AnyObject, _ data: EventData) {
    super.emit(target, data)
  }
  
  open func emit (_ targets: [AnyObject], _ data: EventData) {
    super.emit(targets, data)
  }
  
  public override init () {
    super.init()
  }
  
  fileprivate func castData (_ handler: @escaping (EventData) -> Void) -> (Any!) -> Void {
    return { handler($0 as! EventData) }
  }
}
