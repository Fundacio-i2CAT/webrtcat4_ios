//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation

let SERVER_HOST_URL = "SERVER_HOST_URL"
let TURN_SERVER_UDP = "turn:TURN_SERVER_UDP_HOST:PORT?transport=udp"
let TURN_SERVER_UDP_USERNAME = "USER"
let TURN_SERVER_UDP_PASSWORD = "PASSWORD"
let TURN_SERVER_TCP = "turn:TURN_SERVER_TCP_HOST:PORT?transport=tcp"
let TURN_SERVER_TCP_USERNAME = "USER"
let TURN_SERVER_TCP_PASSWORD = "PASSWORD"

let URL_LOGIN = ""
let USER_KEY = "USERNAME"

let INCOMING_CALL = "INCOMING_CALL"

let URL_BASE = getUrlBase()

func getUrlBase() -> String {
    return SERVER_HOST_URL
}

enum STATE {
    case OK
    case REJECT
    case ERROR
}
