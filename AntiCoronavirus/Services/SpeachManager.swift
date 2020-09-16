//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import AVFoundation
import UIKit

/// Bu sinif ekranda gosterilen text'leri okumayi saglar
class SpeachManager {

    static let shared = SpeachManager()
    private init () {}

    let synth = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()

    /// Siri ile text'i okutur
    /// - Parameter text: gonderilen text
    func readText(_ text: String) {
        utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr")
        synth.speak(utterance)
    }


}
