//
//  PublishFixedMessagesView.swift
//  MQTTAnalyzer
//
//  Created by user on 09.06.20.
//  Copyright © 2020 RoSchmi.
//  All rights reserved.
//

import SwiftUI

struct PublishFixedMessagesView: View {
	
	var function_on_PublishMessageFormView: (String, String) -> Void
	
	@ObservedObject var message: PublishMessageFormModel
	@ObservedObject var fixedMessagesModel: FixedMessagesModel
	
    var body: some View {
		return NavigationView {
			VStack(alignment: .leading) {
				List {
					ForEach(fixedMessagesModel.fixedMessages, id: \.self) { MySelectedMessage in
						PublishFixedMessageCellView(
							function_on_PublishFixedMessagesView:
							{self.handOverToParent(titleParameter: $0, topic: $1)}, fixedMessage: MySelectedMessage, message: self.message, fixedMessagesModel: self.fixedMessagesModel)}
						.onDelete(perform: delete)
				}
			}
			
		}
		.navigationBarTitle(Text("Commands"))
		.navigationBarItems(trailing: Button(action: {self.addRow()})
		{
			Image(systemName: "plus").font(Font.subheadline.weight(.bold))
			
		})
	}
		func delete(at offsets: IndexSet) {
		fixedMessagesModel.fixedMessages.remove(atOffsets: offsets)
    }
	
	func handOverToParent(titleParameter: String, topic: String) {self.function_on_PublishMessageFormView(titleParameter, topic)}
	
	func addRow() {
		let newMessage: FixedMessage = FixedMessage(id: NSUUID().uuidString, title: "DummyAdded",
			explanation: "None", topic: "", message: "", qos: 0, retain: false,
									messageType: MessageType.on_off)
		
		self.fixedMessagesModel.fixedMessages.append(newMessage)
		
	}
}

