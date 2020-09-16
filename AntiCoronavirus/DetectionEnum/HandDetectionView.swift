//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//


import SwiftUI

/// Yuzde el tespit edildiginde gosterilen view.
public struct HandDetectionView: View {

    /// rastgele 6 emojiden birini secer
    let random = [1,2,3,4,5,6].randomElement() ?? 1
    
    public var body: some View {
        VStack(spacing: 32) {
            Image("medium\(random)")
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
            
            FeedbackView(options: handDetectionMessages).padding(.horizontal, 32)
            
        }
    }
    
}
