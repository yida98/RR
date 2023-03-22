//
//  FrequencySlider.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct FrequencySlider: View {
    var frequency: Reminder.Frequency = .frequent
    
    var body: some View {
        HStack {
            ForEach(Reminder.Frequency.allCases, id: \.hashValue) { frequency in
                Rectangle()
                    .fill(Color.green)
                    .id(frequency)
            }
        }
    }
}

struct FrequencySlider_Previews: PreviewProvider {
    static var previews: some View {
        FrequencySlider()
    }
}
