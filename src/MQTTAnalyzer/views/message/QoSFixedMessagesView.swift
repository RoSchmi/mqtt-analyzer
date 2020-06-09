//
//  QoSFixedMessagesView.swift
//  MQTTAnalyzer
//
//  Created by user on 09.06.20.
//  Copyright © 2020 RoSchmi. All rights reserved.
//

import SwiftUI

struct QOSFixedMessagesPicker: View {
	@Binding var qos: Int

	var body: some View {
		Picker(selection: $qos, label: Text("QoS")) {
			Text("0").tag(0)
			Text("1").tag(1)
			Text("2").tag(2)
		}.pickerStyle(SegmentedPickerStyle())
	}
}
