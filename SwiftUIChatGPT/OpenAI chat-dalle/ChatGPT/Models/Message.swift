import Foundation
import UIKit
import SwiftUI

enum MessageType {
    case text
    case image
    case indicator
    case error
}

struct Message: Identifiable, Equatable {
    var id = UUID()
    var content: Any
    let type: MessageType
    let isUserMessage: Bool

    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id && lhs.content as AnyObject === rhs.content as AnyObject && lhs.type == rhs.type && lhs.isUserMessage == rhs.isUserMessage
    }
}
