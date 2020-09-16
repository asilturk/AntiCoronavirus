//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import SwiftUI

/// User tespit edildiginde gosterilen view.
public struct HandUndetectionView: View {
    
    let lastHandDatactedDate: Date?
    
    let random = [1,2,3,4,5,6].randomElement() ?? 1
    
    public var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Image("good\(random)")
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                
                FeedbackView(options: handUndetectionMessages).padding(.horizontal, 32)
            }
            
            lastHandDatactedDate.map { lastFaceTouch in
                VStack(spacing: 8) {
                    Spacer()
                    
                    Text("Yüzüne dokunmadığın süre:")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(nil)
                        .foregroundColor(.white)
                    
                    TimerLabel(date: lastFaceTouch)
                }
                .padding(.all, 32)
            }
        }
    }
}
