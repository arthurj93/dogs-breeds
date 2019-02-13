//
//  Log.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation

func log(_ message: String,
         event: Logger.Event,
         fileName: String = #file,
         line: Int = #line,
         funcName: String = #function) {
    Logger.shared.log(message, event: event, fileName: fileName, line: line, funcName: funcName)
}

final class Logger {
    enum Event: String {
        case error = "‼️ ERROR"
        case info = "ℹ️ INFO"
        case debug = "💬 DEBUG"
        case verbose = "🔬 VERBOSE"
        case warning = "⚠️ WARNING"
        case severe = "🔥 SEVERE"
    }
    
    static let shared = Logger()
    
    var dateFormat = "dd-MM-yyyy hh:mm:ss"
    fileprivate var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    func log(_ message: String,
             event: Event,
             fileName: String = #file,
             line: Int = #line,
             funcName: String = #function) {
        #if DEBUG
        print("\(Date().toString()) \(event.rawValue) [\(sourceFileName(filePath: fileName))]:\(line) \(funcName) -> \(message)")
        #endif
    }
    
    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.last ?? ""
    }
    
}

private extension Date {
    
    func toString() -> String {
        return Logger.shared.dateFormatter.string(from: self)
    }
    
}
