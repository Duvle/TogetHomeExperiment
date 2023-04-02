//
//  DispatchTimer.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/02.
//

import Foundation

class DispatchTimer: NSObject {
    typealias TimerHandler = (DispatchTimer) -> Void
    
    private let timerBlock: TimerHandler
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    private var wrappedBlock: (() -> Void)?
    private let source: DispatchSourceTimer
    
    init(delay: TimeInterval, queue: DispatchQueue, block: @escaping TimerHandler) {
        self.timerBlock = block
        self.queue = queue
        self.delay = delay
        self.source = DispatchSource.makeTimerSource(queue: queue)
        
        super.init()
        
        let wrapper = { () -> Void in
            if !self.source.isCancelled {
                self.source.cancel()
                self.timerBlock(self)
            }
        }
        
        self.wrappedBlock = wrapper
    }
    
    class func scheduledDispatchTimer(delay: TimeInterval, queue: DispatchQueue, block: @escaping TimerHandler) -> DispatchTimer {
        let dipatchTimer = DispatchTimer(delay: delay, queue: queue, block: block)
        dipatchTimer.schedule()
        
        return dipatchTimer
    }
    
    func schedule() {
        self.reschedule()
        self.source.setEventHandler(handler: self.wrappedBlock)
        self.source.resume()
    }
    
    func reschedule() {
        self.source.schedule(deadline: .now() + self.delay)
    }
    
    func resume() {
        self.source.resume()
    }
    
    func cancel() {
        self.source.cancel()
    }
}
