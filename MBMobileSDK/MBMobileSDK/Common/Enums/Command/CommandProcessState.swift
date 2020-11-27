//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandProcessingState

/// The process state of commands that will be passed into the callback
public enum CommandProcessingState<T: CommandErrorProtocol> {
	
	/// The state of the running command has updated.
	/// This case will most likely be called several times with differing states for a running command.
	/// However it is **not** guaranteed that this case will be reached at all.
	case updated(state: VehicleCommandStateType)
	
	/// The running command has faild because of the reasons given in the `errors` array.
	/// There won't be any more invocations of the callback. It is guaranteed that either this `failed`
	/// **or** the `finished` case will eventually be reached. Never both.
	case failed(errors: [T])
	
	/// The running command has finished successfully. It is guaranteed that either this `finished`
	/// **or** the `failed` case will eventually be reached. Never both.
	case finished
}


// MARK: - CommandProcessingMetaData

/// Additional information about the command execution
public struct CommandProcessingMetaData {
	
	/// The timestamp of the state change of the running command.
	/// Beware that there is no strict guarantee for always accending timestamps because
	/// several different sources with possibly differing clocks can generate them.
	public let timestamp: Date
}

// MARK: - VehicleCommandStateType

/// Possible states of a running command besides their termination states `failed` and `finished`.
/// Beware that there is no guarantee that a running command will reach all states.
public enum VehicleCommandStateType: CaseIterable {

	/// The command was successfully transmitted to the vehicle backend.
	/// This state will come after `commandIsAboutToSend`.
	case accepted
    
    /// The command is sent to the socket immediately after this state.
    /// This state will come first.
    case commandIsAboutToSend
	
	/// The requested command was enqueued until a previously requested and currently
	/// running _similar_ command **from the same user** has completed (`failed` or `finished`).
	/// If there is currently a command running from another user the newly requested command
	/// won't get enqueued but rejected instead.
	///
	/// This state will come **after** the `accepted` state, but before the `processing`
	/// and `waiting` states. If there is no other command currently being processed this
	/// state will be skipped.
	case enqueued
	
	/// The command is currently being processed.
	/// This state comes after `accepted` and `enqueued` but before `waiting`.
	case processing
	
	/// The backend is waiting for a response from the vehicle. (can take up to 8 minutes)
	/// This is the last state before one of the completion states is reached (`failed` or `finished`).
	case waiting
}
