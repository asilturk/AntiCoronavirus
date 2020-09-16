//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation
import AVKit

class ViewModel: ObservableObject {
    let manager = UserDetector.Service()

    @Published
    var status: UserDetector.Status = .noUserDetected

    @Published
    var error: Error?

    @Published
    var lastDateOfDetection: Date? = nil

    var cancellables = Set<AnyCancellable>()

    init() {
        manager
            .status
            .removeDuplicates()
            .debounce(for: .seconds(0.35), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveCompletion: { [unowned self] completion in
                guard case .failure(let _) = completion else { return }
            }) { [unowned self] status in
                self.status = status
                switch status {

                case .handDetected:
                    self.lastDateOfDetection = nil

                case .noHandDetected where self.lastDateOfDetection == nil:
                    self.lastDateOfDetection = Date()

                case .noUserDetected, .noHandDetected:
                    break

                }
            }
            .store(in: &cancellables)
    }

    // on camera (.front / .video) ile kullanici izlenmeye baslanir
    func start() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front)

        // cihaz tespit edilemezse baslatilmaz.
        guard let device = discoverySession.devices.first else { return }

        manager.start(device: device)
    }
}
