//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import SwiftUI

// ML modelden gelen tetiklemelere gore ui set eder
struct DetectFaceView: View {
    @ObservedObject
    var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            // insan tespit edilmediginde gosterilecek ui
            NoDetectionView()
                .showView(when: viewModel.status == .noUserDetected)

            // insan tespit edilip el tespit edilmediginde gosterilecek ui
            HandUndetectionView(lastHandDatactedDate: viewModel.lastDateOfDetection)
                .showView(when: viewModel.status == .noHandDetected)

            // el tespit edildiginde gosterilecek ui
            HandDetectionView()
                .showView(when: viewModel.status == .handDetected)
        }
        .onAppear { self.viewModel.start() }
    }
}


