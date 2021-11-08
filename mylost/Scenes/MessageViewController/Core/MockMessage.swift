import Foundation
import UIKit
import CoreLocation
import MessageKit
import AVFoundation
import Components

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

private struct CoordinateItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

    init(imageURL: URL) {
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = Resourcebook.Image.Icons48.systemSendFill.image
    }
}

private struct MockAudioItem: AudioItem {

    var url: URL
    var size: CGSize
    var duration: Float

    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        // compute duration
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }

}

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
    
}

struct MockLinkItem: LinkItem {
    let text: String?
    let attributedText: NSAttributedString?
    let url: URL
    let title: String?
    let teaser: String
    let thumbnailImage: UIImage
}

internal struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind

    var user: MockUser

    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }

    init(text: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }

    init(image: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(imageURL: URL, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(imageURL: imageURL)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(location: CLLocation, user: MockUser, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
    }

    init(emoji: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
    }

    init(audioURL: URL, user: MockUser, messageId: String, date: Date) {
        let audioItem = MockAudioItem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
    }

    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
    }

    init(linkItem: LinkItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .linkPreview(linkItem), user: user, messageId: messageId, date: date)
    }
}

//////////////////////
final class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?
    
    private var queuedMessage: MockMessage?
    
    private var onNewMessageCode: ((MockMessage) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var connectedUsers: [MockUser] = []
    
    private init() {}
    
    @discardableResult
    func connect(with senders: [MockUser]) -> Self {
        disconnect()
        connectedUsers = senders
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        onTypingStatusCode = nil
        onNewMessageCode = nil
        return self
    }
    
    @discardableResult
    func onNewMessage(code: @escaping (MockMessage) -> Void) -> Self {
        onNewMessageCode = code
        return self
    }
    
    @discardableResult
    func onTypingStatus(code: @escaping () -> Void) -> Self {
        onTypingStatusCode = code
        return self
    }
    
    @objc
    private func handleTimer() {
        if let message = queuedMessage {
            onNewMessageCode?(message)
            queuedMessage = nil
        } else {
            queuedMessage = .init(text: "sd", user: .init(senderId: "1", displayName: "yoo"), messageId: "0", date: Date())
            onTypingStatusCode?()
        }
    }
}
