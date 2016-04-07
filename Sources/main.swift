import Vapor
import MongoKitten


let me = WebUser()
let session = WebSession(history: [], contributors: [me])!
let entity = Website(sessions: ["master": session], owner: me)!


let app = Application()

app.get("read") { request in
    let user = me
    var response = ""
    
    if entity.owner.uniqueIdentifier == user.uniqueIdentifier {
        response += "owner: \(user.uniqueIdentifier)\n\n"
    } else {
        response += "collaborator: \(user.uniqueIdentifier)\n\n"
    }
    
    for node in entity.primarySession.history {
        response += node.serialize() + "\n\n"
    }
    
    return response
}

app.get("write", String.self) { request, action in
    let user = me
    
    let node = WebNode(epochTime: 0, event: WebEvent(action: action)!, blame: user.uniqueIdentifier)!
    
    entity.primarySession.history.append(node)
    return "Written \(node.serialize() as String)"
}

app.start(port: 8080)