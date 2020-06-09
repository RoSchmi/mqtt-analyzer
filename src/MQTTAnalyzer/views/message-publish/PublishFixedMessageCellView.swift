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
	
	var function_on_PublishFixedMessagesView: (String, String) -> Void
	
	@ObservedObject var fixedMessage: FixedMessage
	
	@ObservedObject var message: PublishMessageFormModel
	@ObservedObject var fixedMessagesModel: FixedMessagesModel
	
    var body: some View {
		/*
		NavigationLink(destination: PublishFixedMessageDetailView( fixedMessage: fixedMessage, message: message, fixedMessagesModel: fixedMessagesModel)) {
			*/
		NavigationLink(destination: PublishFixedMessageDetailView(function_on_PublishFixedMessageCellView:
			
			{self.handOverToParent(titleParameter: $0, topic: $1)}, fixedMessage: fixedMessage, message: message)) {
				
				VStack(alignment: .leading) {
				HStack {
					Text("\(fixedMessage.title)")
					Spacer()
					//Text("\(fixedMessage.messageType)")
					
				}
			}
			
		}
		
		
	}
	func handOverToParent(titleParameter: String, topic: String)
		//{print(titleParameter)}
	{self.function_on_PublishFixedMessagesView(titleParameter, topic)}
}

