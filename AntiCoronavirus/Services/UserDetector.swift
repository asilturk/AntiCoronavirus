//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import Vision
import Combine
import AVFoundation
import AVKit

// ML modelden aldigi bilgiler ile user yuzu tespit edilerek ellerini kullanmasi durumunda feedback gonderilir.
public class UserDetector {
    enum Status: Equatable {
        case noUserDetected
        case noHandDetected
        case handDetected
    }

    class Service {
        enum Error: Swift.Error {
            case captureSessionError(Swift.Error)
            case permissionError(Swift.Error)
            case visionError(Swift.Error)
        }

        private let subject = PassthroughSubject<Status, Error>()
        lazy var status = subject.eraseToAnyPublisher()

        private var det: Detect?

        func start(device: AVCaptureDevice) {
            guard det == nil else { return }
            det = Detect(device: device, subject: subject)
        }

        func stop() {
            det = nil
        }
    }

    private let model = try! VNCoreMLModel(for: MLModel(contentsOf: FaceTouch.urlOfModelInThisBundle))
    private let handler = VNSequenceRequestHandler()

    func detect(image: CIImage) throws -> Status {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        let faceTouchDetectionRequest = VNCoreMLRequest(model: model)

        try handler.perform([faceDetectionRequest, faceTouchDetectionRequest], on: image, orientation: .leftMirrored)
        let faces = faceDetectionRequest.results?.compactMap { $0 as? VNFaceObservation } ?? []

        guard !faces.isEmpty else { return .noUserDetected }

        if let classification = faceTouchDetectionRequest.results?.compactMap({ $0 as? VNClassificationObservation }).first,
            classification.identifier == "touched",
            classification.confidence > 0.5 {

            return .handDetected
        }

        return .noHandDetected
    }


}

// MARK: - UserDetector.Service 
extension UserDetector.Service {

    private class Detect: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        private let detector = UserDetector()
        private let session = AVCaptureSession()
        private let output = AVCaptureVideoDataOutput()
        private let subject: PassthroughSubject<UserDetector.Status, Error>

        init(device: AVCaptureDevice, subject: PassthroughSubject<UserDetector.Status, Error>) {
            self.subject = subject
            super.init()

            do {
                let deviceInput = try AVCaptureDeviceInput(device: device)
                session.beginConfiguration()

                if session.canAddInput(deviceInput) {
                    session.addInput(deviceInput)
                }

                let output = AVCaptureVideoDataOutput()
                output.videoSettings = [
                    String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
                ]

                output.alwaysDiscardsLateVideoFrames = true

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                session.commitConfiguration()
                output.setSampleBufferDelegate(self, queue: .global())
            } catch {
                subject.send(completion: .failure(.captureSessionError(error)))
            }

            session.startRunning()
        }

        deinit {
            session.stopRunning()
        }

        func captureOutput(_ output: AVCaptureOutput,
                           didOutput sampleBuffer: CMSampleBuffer,
                           from connection: AVCaptureConnection) {

            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)

            let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault,
                                                            target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)

            let image = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [CIImageOption : Any]?)
            do {
                subject.send(try detector.detect(image: image))
            } catch {
                subject.send(completion: .failure(.visionError(error)))
            }
        }
    }

}

