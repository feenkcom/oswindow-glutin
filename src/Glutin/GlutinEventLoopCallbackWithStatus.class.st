Class {
	#name : #GlutinEventLoopCallbackWithStatus,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_CALLBACK',
		'OFFSET_IS_RUNNING',
		'OFFSET_IS_VALID'
	],
	#category : #'Glutin-Event Loop'
}

{ #category : #'field definition' }
GlutinEventLoopCallbackWithStatus class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		bool is_valid
		bool is_running
		GlutinEventCallback callback
 	)
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> callback [
	"This method was automatically generated"
	^GlutinEventCallback forAddress: ((handle pointerAt: OFFSET_CALLBACK) asInteger)
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> callback: anObject [
	"This method was automatically generated"
	handle 
		pointerAt: OFFSET_CALLBACK
		put: (anObject 
			ifNotNil: [ ExternalAddress fromAddress: anObject thunk address ]
			ifNil: [ ExternalAddress null ])
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> is_running [
	"This method was automatically generated"
	^handle booleanAt: OFFSET_IS_RUNNING
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> is_running: anObject [
	"This method was automatically generated"
	handle booleanAt: OFFSET_IS_RUNNING put: anObject
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> is_valid [
	"This method was automatically generated"
	^handle booleanAt: OFFSET_IS_VALID
]

{ #category : #'accessing structure variables' }
GlutinEventLoopCallbackWithStatus >> is_valid: anObject [
	"This method was automatically generated"
	handle booleanAt: OFFSET_IS_VALID put: anObject
]