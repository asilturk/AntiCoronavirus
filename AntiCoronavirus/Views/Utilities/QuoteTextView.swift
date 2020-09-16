//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    @ObservedObject
    private var label: Label

    init(options: [String]) {
        label = Label(options: options)
    }

    var body: some View {
        return Text(label.currentText)
            .font(.largeTitle)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(5)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear {
                self.label.start()
        }
    }
}

private class Label: ObservableObject {
    @Published
    var currentText: String

    private let options: [String]
    private var timer: Timer?

    init(options: [String]) {
        currentText = options.randomElement()!
        self.options = options
    }

    deinit {
        timer?.invalidate()
    }

    func start(timeInterval: TimeInterval = 8) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [unowned self] _ in
            withAnimation(.default) {
                self.currentText = self.options.randomElement()!
            }
        }

        SpeachManager.shared.readText(currentText)

    }
}
