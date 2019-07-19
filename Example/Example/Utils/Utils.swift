//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation
import AVFoundation

class Utils {
    
 
    func isLogged()->Bool{
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: USER_KEY) != nil){
            return true
        }
        return false
        
    }
    
    func getStateString(state:STATE)->String{
        
        if(state == STATE.ERROR){
            return "ERROR"
        }
        if(state == STATE.OK){
            return "OK"
        }
        if(state == STATE.REJECT){
            return "REJECT"
        }
        
        return "UNKOWN"
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        //let seconds = Int(time) % 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = Bundle.main.path(forResource: file as String, ofType: type as String)
        let url = NSURL.fileURL(withPath: path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
}

