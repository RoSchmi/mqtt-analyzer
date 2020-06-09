//
//  PublishFixedMessageDetailView.swift
//  MQTTAnalyzer
//
//  Created by user on 09.06.20.
//  Copyright © 2020 RoSchmi.
// All rights reserved.
//

import SwiftUI
import Foundation
import SwiftyJSON
import swift_petitparser


struct PublishFixedMessageDetailView: View {
	
	var function_on_PublishFixedMessageCellView: (String, String) -> Void
	
	//@State var fixedMessage: FixedMessage
	@ObservedObject var fixedMessage: FixedMessage
	
	@ObservedObject var message: PublishMessageFormModel
	
	//@ObservedObject var fixedMessagesModel: FixedMessagesModel
	
	//let closeFixedMessagesCallback: () -> Void
	//let root: RootModel
	//let host: Host
	
	//@Binding var type: PublishFixedMessageType
	
	var body: some View {
			//NavigationView {
			Form {
				VStack(alignment: HorizontalAlignment.leading) {
				
			Section(header: HStack {Text(""); Spacer()}) {
				Text("")
			}
			Section(header: HStack {Text("Title"); Spacer()}) {
			TextField("#", text: $fixedMessage.title)
			.disableAutocorrection(true)
			.autocapitalization(.none)
			.font(.body)
			.background(Color.secondary)
					}
								
			Section(header: HStack {Text("Function"); Spacer()}) {
			TextField("#", text: $fixedMessage.explanation)
			.disableAutocorrection(true)
			.autocapitalization(.none)
			.font(.body)
			.background(Color.secondary)
					}
			Section(header: HStack {Text("Topic"); Spacer()}) {
				TextField("#", text: $fixedMessage.topic)
				.disableAutocorrection(true)
				.autocapitalization(.none)
				.font(.body)
				.background(Color.secondary)
			}
				
			Section(header: HStack {Text("Settings"); Spacer()}) {
				HStack {
					Text("QoS")
					QOSFixedMessagesPicker(qos: $fixedMessage.qos)
				}
				
				Toggle(isOn: $fixedMessage.retain) {
					Text("Retain")
				}
			}
			
			Section(header: HStack {Text("Message"); Spacer()}) {
					PublishFixedMessageFormPlainTextView(fMessage: $fixedMessage.message)
				
				Section(header: HStack {Text(""); Spacer()}) {
				Text("")
				Text("")
				Text("")
				Text("")
				Text("")
				Text("")
	            Text("")
				Text("")
				Text("")
			}
			Section(header: HStack {Text(""); Spacer()}) {
				Text("")
				Text("")
				Text("")
				}
			
		}
	}
		.navigationBarTitle(  "Command", displayMode: .inline)
		.navigationBarItems(leading: Button("", action: {}), trailing: Button(action: self.send) {Text("Publish").font(.headline)})
		}
	}
	//func send() {}
	
	func send() { self.function_on_PublishFixedMessageCellView(fixedMessage.title, fixedMessage.topic)}
		
		
		
		/*
		if model.messageType == .json {
			model.updateMessageFromJsonData()
		}
		*/
		/*
		let msg = Message(data: model.message,
						  date: Date.init(),
						  qos: Int32(model.qos),
						  retain: model.retain,
						  topic: model.topic)
		*/
		/*
		let msg = Message(data: fixedMessage.message,
		date: Date.init(),
		qos: Int32(fixedMessage.qos),
		retain: fixedMessage.retain,
		topic: fixedMessage.topic)
		*/
		//root.publish(message: msg, on: self.host)

	    
		
		//closeFixedMessagesCallback()
	}
	

//	func cancel() {
		//closeFixedMessagesCallback()
//	}

struct PublishFixedMessageFormPlainTextView: View {
	@Binding var fMessage: String
	
	var body: some View {
		Group {
			MessageFixedTextView(text: $fMessage)
			.disableAutocorrection(true)
			.autocapitalization(.none)
			.font(.system(.body, design: .monospaced))
			.frame(height: 50)
			.background(Color.secondary)
		}
	}
}
