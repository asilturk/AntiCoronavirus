//  
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//

import SwiftUI

extension View {

    /// SwiftUI Stack yapisi geregi, 3 tip view'den hangisinin gosterilecegine karar verir
    /// - Parameter show: sarti saglayacak parametre
    /// - Returns: gosterilecek view
    func showView(when show: Bool) -> some View {
        return show ? AnimateAppearence(content: self) : nil
    }
    
}

// ML modelden tetiklenen metotlar sonrasi feedback view'leri animation ile yeniler
public struct AnimateAppearence<Content: View>: View {
    let content: Content

    @State
    private var animating: Bool = false

    public var body: some View {
        content
            .opacity(animating ? 1 : 0)
            .animation(.easeOut(duration: 0.2))
            .scaleEffect(animating ? 1 : 0, anchor: .center)
            .animation(.easeInOut(duration: 0.3))
            .onAppear {
                self.animating.toggle()
            }
    }
}
