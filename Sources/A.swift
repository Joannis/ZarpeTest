import Zarpedon
import MongoKitten

class Website: ZarpedonEntity {
    typealias Session = WebSession
    
    var owner: Session.HistoryNode.User
    var primarySession: WebSession
    var sessions: [String: WebSession]
    
    init?(sessions: [String: WebSession], owner: Session.HistoryNode.User) {
        guard let primary = sessions["master"] else {
            return nil
        }
        
        self.owner = owner
        primarySession = primary
        self.sessions = sessions
    }
}

class WebSession: ZarpedonSession {
    typealias HistoryNode = WebNode
    
    var contributors: [HistoryNode.User]
    var history: [HistoryNode]
    
    init?(history: [HistoryNode], contributors: [HistoryNode.User]) {
        self.contributors = contributors
        self.history = history
    }
}

class WebNode: ZarpedonHistoryNode {
    typealias State = WebState
    typealias Event = WebEvent
    typealias User = WebUser
    
    var epochTime: Int32
    var event: Event
    var blame: String
    
    init?(epochTime: Int32, event: Event, blame: String) {
        self.epochTime = epochTime
        self.event = event
        self.blame = blame
    }
    
    func makeState() -> State {
        return State.init()
    }
    
    func asDocument() -> Document {
        return [
                   "epoch": epochTime,
                   "event": event.asDocument(),
                   "blame": blame
        ]
    }
    
    func serialize() -> [UInt8] {
        return asDocument().bsonData
    }
    
    func serialize() -> String {
        return asDocument().bsonDescription
    }
}

struct WebState: ZarpedonState {
    func asDocument() -> Document {
        return []
    }
    
    func serialize() -> [UInt8] {
        return asDocument().bsonData
    }
    
    func serialize() -> String {
        return asDocument().bsonDescription
    }
}

struct WebEvent: Zarpevent {
    let action: Action
    
    enum Action: String {
        case ButtonClick = "click"
        case ImportFile = "import"
    }
    
    init?(action: String) {
        guard let a = Action.init(rawValue: action) else {
            return nil
        }
        
        self.action = a
    }
    
    func asDocument() -> Document {
        return [
                   "action": action.rawValue
        ]
    }
    
    func serialize() -> [UInt8] {
        return asDocument().bsonData
    }
    
    func serialize() -> String {
        return asDocument().bsonDescription
    }
}

struct WebUser: Contributor {
    var uniqueIdentifier = "joannis@orlandos.nl"
    var pass = "123"
    
    func asDocument() -> Document {
        return [
                   "email": uniqueIdentifier
        ]
    }
    
    func serialize() -> [UInt8] {
        return asDocument().bsonData
    }
    
    func serialize() -> String {
        return asDocument().bsonDescription
    }
}