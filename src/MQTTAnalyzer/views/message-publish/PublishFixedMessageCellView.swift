//
//  PublishFixedMessageCellView.swift
//  MQTTAnalyzer
//
//  Created by user on 09.06.20.
//  Copyright © 2020 RoSchmi. All rights reserved.
//

import SwiftUI


import SwiftUI

struct PublishFixedMessageCellView: View {
	
	var function_on_PublishFixedMessagesView: (String, String, Int, Bool) -> Void
	
	@ObservedObject var fixedMessage: FixedMessage
	
	@ObservedObject var message: PublishMessageFormModel
	@ObservedObject var fixedMessagesModel: FixedMessagesModel
	
    var body: some View {
		NavigationLink(destination: PublishFixedMessageDetailView(function_on_PublishFixedMessageCellView: {
				self.handOverToParent(pMessage: $0, pTopic: $1, pQos: $2, pRetain: $3)}, fixedMessage: fixedMessage, message: message)) {
				
				VStack(alignment: .leading) {
				HStack {
					Text("\(fixedMessage.title)")
					Spacer()
					//Text("\(fixedMessage.messageType)")
					
				}
			}
		}
	}
	func handOverToParent(pMessage: String, pTopic: String, pQos: Int, pRetain: Bool)
		//{print(titleParameter)}
	{self.function_on_PublishFixedMessagesView(pMessage, pTopic, pQos, pRetain)}
}
